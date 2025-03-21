// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailBloc extends Bloc<TripDetailEvent, TripDetailState> {

  AuthUseCases authUseCases;
  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;

  // Constructor
  TripDetailBloc(
    this.authUseCases,
    this.geolocationUseCases, 
    this.driverTripRequestsUseCases,
    this.socketUseCases, 
    this.socketIOBloc
  ): super(TripDetailState(
    responseGetTripDetail: Loading(),
    showNewReservesOnTrip: false
  )) {
     
    on<GetTripDetail>((event, emit) async {
      emit(
        state.copyWith(
          responseGetTripDetail: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el detalle de un viaje
      Resource<TripDetail> tripDetailRes = await driverTripRequestsUseCases.getTripDetailUseCase.run(event.idTrip);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseGetTripDetail: tripDetailRes,
          showNewReservesOnTrip: false
        ),
      );

      if (tripDetailRes is Success<TripDetail>) {
        print('GetTripDetail ---------------------');
        print(tripDetailRes.data);

        TripDetail tripDetail = tripDetailRes.data;

        emit(
          state.copyWith(
            idTrip: tripDetail.idTrip,
            pickUpLatLng: LatLng(tripDetail.pickupLat, tripDetail.pickupLng),
            destinationLatLng: LatLng(tripDetail.destinationLat, tripDetail.destinationLng)
          )
        );

        // Inicializando el Mapa
        add(TripDetailInitMap());

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        add(ListenTripReservesSocketIO(idTrip: tripDetail.idTrip));

      } else if (tripDetailRes is ErrorData<TripDetail>) {
        print('Error al obtener los datos del Detalle de Viaje: ${tripDetailRes.message}');
      }
    }); 

    // Iniciamos el viaje - Cambiamos el estado del viaje en la BD
    on<ChangeTripStatus>((event, emit) async {
      print('Entrando a ChangeTripStatus -------------------------------------');

      emit(
        state.copyWith(
          responseStartTrip: Loading(),
        )
      );

      // Actualizando el estado del viaje -> 3 = INCOURSE
      Resource updateTripStatusRes = await driverTripRequestsUseCases.updateTripStatusUseCase.run(event.idTrip.toInt(), 3);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseStartTrip: updateTripStatusRes,
        ),
      );
    });

    on<TripDetailInitMap>((event, emit) async {
      print('TripDetailInitMap -------------------------------------');
      print('Origin: ${state.pickUpLatLng} - Destination: ${state.destinationLatLng}');

      // Inicializo el controlador del mapa cada vez que ingreso a la pantalla con Mapa
      Completer<GoogleMapController> initializeController = Completer<GoogleMapController>();
      
      emit(
        state.copyWith(
          controller: initializeController,
        )
      );
      
      // Defino los Markers aca para que primero se inicialicen las posiciones
      // Trayendo las imagenes de los marker que coloco en el mapa al trazar la ruta
      BitmapDescriptor pickUpMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-small.png');
      BitmapDescriptor destinationMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-green-small.png');

      // Actualizando estado de los marcadores
      Marker markerPickUp = geolocationUseCases.getMarker.run(
        'originLocation',
        state.pickUpLatLng!.latitude,
        state.pickUpLatLng!.longitude,
        'Lugar de Origen',
        '',
        pickUpMarkerImg
      );

      Marker markerDestination = geolocationUseCases.getMarker.run(
        'destinationLocation',
        state.destinationLatLng!.latitude,
        state.destinationLatLng!.longitude,
        'Lugar de Destino',
        '',
        destinationMarkerImg
      );

      emit(
        state.copyWith(
          markers: {
            markerPickUp.markerId: markerPickUp,
            markerDestination.markerId: markerDestination,
          }
        )
      );

      // Agregando la Ruta
      add(AddPolyline());
    });

    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition  -------------------------------------');
      print(event.pickUpLatLng);
      print(event.destinationLatLng);

      try {
        // GoogleMapController googleMapController = await state.controller!.future;

        // Obteniendo el controller inicializado para ejecutar el movimiento de la camara
        final googleMapController = await state.controller!.future;

        // Calcula los límites usando pickUpLatLng y destinationLatLng
        LatLngBounds bounds = calculateBounds(event.pickUpLatLng, event.destinationLatLng);

        await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 16));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    });  

    // Agregando la ruta al mapa
    on<AddPolyline>((event, emit) async {
      print('Entrando a AddPolyline  -------------------------------------');
      // Obteniendo las coordenadas del origen y destino
      List<LatLng> polylineCoordinates = await geolocationUseCases.getPolyline.run(state.pickUpLatLng!, state.destinationLatLng!);

      PolylineId id = const PolylineId("MyRoute"); // Id de la ruta
      Polyline polyline = Polyline(
        polylineId: id, 
        color: Colors.blueAccent, 
        points: polylineCoordinates, // LatLng Origen/Destino
        width: 6  // Tamaño de la ruta en el mapa
      );
      emit(
        state.copyWith(
          polylines: {
            id: polyline
          }
        )
      );

      // Modificando la posicion de la camara en el mapa
      add(ChangeMapCameraPosition(
        pickUpLatLng: state.pickUpLatLng!, 
        destinationLatLng: state.destinationLatLng!
      ));
    });

    // Escuchamos las nuevas reservas realizadas en el Viaje del conductor
    on<ListenTripReservesSocketIO>((event, emit) async {
      print('Escuchando reservas de pasajeros hechas al viajes >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(socketIOBloc.state.socket);
      print(socketIOBloc.state.socket?.connected);

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Trip Detail: ${authResponse.user?.idUser}');

        if (socketIOBloc.state.socket != null && socketIOBloc.state.socket!.connected) {
          // Creamos un StreamController para gestionar la emisión
          final controller = StreamController<void>();
          
          // Esta NOTIFICACIÓN solo la escucha el usuario al cual pertenece el viaje
          socketIOBloc.state.socket?.on('create_reserve_trip_notification/${authResponse.user?.idUser}/${event.idTrip}', (data) async {
            print('Obteniendo la Nueva Reserva Creada - Socket IO');
            print(data);

            // Habilitando el mensaje de nuevos viajes disponibles
            emit(state.copyWith(
              showNewReservesOnTrip: true, 
            ));

            // Cuando el evento se haya procesado, cerramos el controller
            controller.add(null);
          });

          // Esperar a que el evento se haya completado
          await controller.stream.first;
          await controller.close();

          // Cerramos la escucha para no recibir más eventos hasta que se recargue la pantalla
          socketIOBloc.state.socket?.off('create_reserve_trip_notification/${authResponse.user?.idUser}/${event.idTrip}');
        } else {
          print('******************* Driver Trip Detail Emit Socket - AuthResponse es Null *******************');
        }
      }
    });

    // Emitiendo la notificacion de viaje finalizado
    on<EmitUpdateStatusTripSocketIO>((event, emit) async {
      print('Emitiendo el comienzo del viaje >>>>>>>>>>>>>>>>>>>>>');
      
      if(socketIOBloc.state.socket != null) {
        print('Emitiendo');
        socketIOBloc.state.socket?.emit('update_status_trip', {
          "trip_id": state.idTrip,
        });
      }
    });

    // Reseteo los valores del State al salir de pantalla
    on<ResetState>((event, emit) {
      print('reseteo');
      emit(const TripDetailState()); // Emitimos el estado inicial limpio.
    });
  }

  Future<void> setMapController(GoogleMapController controller) async {
    // Completando el controlador del Mapa
    if (!state.controller!.isCompleted) {
      print('Completando el controlador del mapa');
      state.controller!.complete(controller);
    } 
  }

  // Funcion para calcular los limites de la ruta, y poder realizar el movimiento de la camara
  LatLngBounds calculateBounds(LatLng pickUp, LatLng destination) {
    LatLngBounds bounds;

    if (pickUp.latitude > destination.latitude && pickUp.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: pickUp);
    } else if (pickUp.longitude > destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickUp.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, pickUp.longitude));
    } else if (pickUp.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, pickUp.longitude),
        northeast: LatLng(pickUp.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickUp, northeast: destination);
    }

    return bounds;
  }
}