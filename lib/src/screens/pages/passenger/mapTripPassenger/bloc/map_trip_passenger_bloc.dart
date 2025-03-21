// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTripPassengerBloc extends Bloc<MapTripPassengerEvent, MapTripPassengerState> {

  AuthUseCases authUseCases;
  ReserveUseCases reserveUseCases;
  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  // SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;

  // Constructor
  MapTripPassengerBloc(
    this.authUseCases,
    this.reserveUseCases, 
    this.geolocationUseCases, 
    this.driverTripRequestsUseCases,
    // this.socketUseCases, 
    this.socketIOBloc
  ): super(MapTripPassengerState(

  )) {
    on<GetMapReserveDetail>((event, emit) async {
      print('GetMapReserveDetail -------------------------------------');
      
      emit(
        state.copyWith(
          responseGetReserveDetail: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el resultado
      Resource<ReserveDetail> responseReserveDetail = await reserveUseCases.getReserveDetailUseCase.run(event.idReserve);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseGetReserveDetail: responseReserveDetail,
        ),
      );

      if (responseReserveDetail is Success<ReserveDetail>) {
        print('Response Success');
        ReserveDetail data = responseReserveDetail.data;

        emit(
          state.copyWith(
            isPaid: data.isPaid,
            pickUpLatLng: LatLng(data.tripRequest.pickupLat, data.tripRequest.pickupLng),
            destinationLatLng: LatLng(data.tripRequest.destinationLat, data.tripRequest.destinationLng),
          ),
        );
        
        // Inicializando el Mapa
        add(MapTripPassangerInitMap());

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        add(ListenDriverPositionSocketIO());
        add(ListenUpdateStatusTripSocketIO());
      }
    });


    on<MapTripPassangerInitMap>((event, emit) async {
      print('InitializeMap -------------------------------------');
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
      // add(AddPolyline());
    });

    on<AddMarkerDriver>((event, emit) async {
      print('AddMarkerDriver: ${event.lat} y ${event.lng}');
      BitmapDescriptor driverMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-current-location.png');
      print('Añadiendo el Marker');
      Marker markerDriver = geolocationUseCases.getMarker.run(
        'driver',
        event.lat,
        event.lng,
        'Tu conductor',
        '',
        driverMarkerImg
      );
      print('Añadiendo el Marker V2');

      emit(
        state.copyWith(
          markers: Map.of(state.markers)..[markerDriver.markerId] = markerDriver
        )
      );
    });


    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition ------------------------------------');
      print('LAT: ${event.lat} y LNG: ${event.lng}');

      try {
        GoogleMapController googleMapController = await state.controller!.future;
        
        await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.lat, event.lng),
            zoom: 18,
            bearing: 0
          )
        ));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    });


    // Agregando la ruta al mapa
    on<AddPolyline>((event, emit) async {
      print(state.destinationLatLng);
      // Obteniendo las coordenadas del origen y destino
      List<LatLng> polylineCoordinates = await geolocationUseCases.getPolyline.run(
        LatLng(event.driverLat, event.driverLng), 
        state.destinationLatLng!
      );

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
          },
          isRouteDrawed: true
        )
      );
    });

    // Trayendo los datos: Teimpo estimado del trayecto y Distancia del punto de origen al punto de destino
    on<GetTimeAndDistanceValues>((event, emit) async {
      emit(
        state.copyWith(
          responseTimeAndDistance: null
        )
      );

      Resource response = await driverTripRequestsUseCases.getTimeAndDistance.run(
        event.driverLat,
        event.driverLng,
        state.destinationLatLng!.latitude,
        state.destinationLatLng!.longitude,
        "now"
        // Eliminar ese NOW cuando controle el horario
        // state.departureTime! 
      );

      print('Em TimeAndDistanc');
      if (response is Success<TimeAndDistanceValues>) {    
        final data = response.data;
        print('Emitiendo TimeAndDistance');
        emit(
          state.copyWith(
            timeAndDistance: data
          )
        );
      }
    });

    // Emitimos la finalizacion del viaje
    on<TripFinishedEvent>((event, emit) {
      emit(
        state.copyWith(
          tripFinished: true
        )
      );
    });

    // Reseteo los valores del State al salir de pantalla
    on<ResetState>((event, emit) async {
      print('reseteo');
      
      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Map Trip Passenger: ${authResponse.user?.idUser}');
        // Desuscribirse del evento del socket
        socketIOBloc.state.socket?.off('new_driver_position_trip/${authResponse.user?.idUser}');
      }

      emit(const MapTripPassengerState()); // Emitimos el estado inicial limpio.
    });

    // Escuchando los cambios de ubicación del Driver
    on<ListenDriverPositionSocketIO>((event, emit) async {
      print('Escuchando la ubicación del driver >>>>>>>>>>>>>>>>>>>>>');
      
      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Map Trip Passenger: ${authResponse.user?.idUser}');

        if(socketIOBloc.state.socket != null) {
          print('Escuchando');
          
          socketIOBloc.state.socket?.on('new_driver_position_trip/${authResponse.user?.idUser}', (data) {
            print('Escuchando la ubicación del driver >>>>>>>>>>>');
            print(data);

            // Actualizamos el marcador segun la ubicacion del Driver
            add(AddMarkerDriver(
              lat: data['lat'] as double, 
              lng: data['lng'] as double
            ));

            // Actualizamos la ruta segun la posicion del driver si aun no ha sido trazada
            add(AddPolyline(
              driverLat: data['lat'] as double, 
              driverLng: data['lng'] as double
            ));

            // Modificando la posicion de la camara en el mapa
            add(ChangeMapCameraPosition(
              lat: data['lat'] as double, 
              lng: data['lng'] as double
            ));

            // Actualizando el tiempo de llegada a destino
            add(GetTimeAndDistanceValues(
              driverLat: data['lat'] as double, 
              driverLng: data['lng'] as double
            ));
          });
        }
      } else {
        print('******************* Passenger Trip Available Detail Emit Socket - AuthResponse es Null *******************');
      }
    });

    // Escuchando la finalización del viaje
    on<ListenUpdateStatusTripSocketIO>((event, emit) async {
      print('Escuchando la finalización del viaje >>>>>>>>>>>>>>>>>>>>>');

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Map Trip Passenger: ${authResponse.user?.idUser}');

        if(socketIOBloc.state.socket != null) {
          print('Escuchando ListeUpdateStatusTripSocketIO');
          
          socketIOBloc.state.socket?.on('trip_status_update/${authResponse.user?.idUser}', (data) {
            if (state.tripFinished != true) {
              add(TripFinishedEvent());
            }
          });
        }
      } else {
        print('******************* Passenger Trip Listen Update Trip Socket - AuthResponse es Null *******************');
      }
    });
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