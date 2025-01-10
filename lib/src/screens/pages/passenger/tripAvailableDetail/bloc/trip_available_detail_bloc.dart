// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/reserve_request.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
// import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TripAvailableDetailBloc extends Bloc<TripAvailableDetailEvent, TripAvailableDetailState> {

  AuthUseCases authUseCases;
  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  ReserveUseCases reserveUseCases;
  SocketIOBloc socketIOBloc;
  
  // Opcion 2 que anda el controller **********************************************
  // Completer<GoogleMapController> _mapControllerCompleter = Completer<GoogleMapController>();
  // Opcion 2 que anda el controller **********************************************

  TripAvailableDetailBloc(
    this.authUseCases,
    this.geolocationUseCases, 
    this.driverTripRequestsUseCases, 
    this.reserveUseCases,
    this.socketIOBloc
  ): super(const TripAvailableDetailState(
    responseReserve: null
  )) {

    on<TripAvailableDetailInitEvent>((event, emit) async {
      // Inicializo el controlador del mapa cada vez que ingreso a la pantalla con Mapa
      Completer<GoogleMapController> initializeController = Completer<GoogleMapController>();

      // Opcion 2 que anda el controller **********************************************
      // if (_mapControllerCompleter.isCompleted) {
      //   print('Reiniciando el mapa');

      //   // Reiniciar el Completer si ya está completado
      //   _mapControllerCompleter = Completer<GoogleMapController>();
      // }
      // Opcion 2 que anda el controller **********************************************

      emit(
        state.copyWith(
          pickUpText: event.pickUpText,
          pickUpLatLng: event.pickUpLatLng,
          destinationText: event.destinationText,
          destinationLatLng: event.destinationLatLng,
          departureTime: event.departureTime,
          compensation: event.compensation,
          driver: event.driver,
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
    });

    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition -------------------------------------');
      print(event.pickUpLatLng);
      print(event.destinationLatLng);

      try {
        // Opcion 2 que anda el controller **********************************************
        // final googleMapController = await _mapControllerCompleter.future;
        // Opcion 2 que anda el controller **********************************************

        // Obteniendo el controller inicializado para ejecutar el movimiento de la camara
        final googleMapController = await state.controller!.future;

        // Calcula los límites usando pickUpLatLng y destinationLatLng
        LatLngBounds bounds = calculateBounds(event.pickUpLatLng, event.destinationLatLng);

        await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 150));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    });

    // Agregando la ruta al mapa
    on<AddPolyline>((event, emit) async {
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
    });

    // Trayendo los datos: Teimpo estimado del trayecto y Distancia del punto de origen al punto de destino
    // on<GetTimeAndDistanceValues>((event, emit) async {
    //   emit(
    //     state.copyWith(
    //       responseTimeAndDistance: Loading()
    //     )
    //   );
    //   Resource<TimeAndDistanceValues> response = await driverTripRequestsUseCases.getTimeAndDistance.run(
    //     state.pickUpLatLng!.latitude,
    //     state.pickUpLatLng!.longitude,
    //     state.destinationLatLng!.latitude,
    //     state.destinationLatLng!.longitude,
    //   );
    //   emit(
    //     state.copyWith(
    //       responseTimeAndDistance: response
    //     )
    //   );
    // });

    on<CreateReserve>((event, emit) async {
      ReserveRequest reserveRequest = ReserveRequest(
        tripRequestId: event.tripRequestId, 
        isPaid: true
      );

      emit(
        state.copyWith(
          responseReserve: Loading()
        )
      );

      Resource<ReserveDetail> reserveDetailRes = await reserveUseCases.createReserve.run(reserveRequest);
      print('reserveDetailRes');
      print(reserveDetailRes);

      emit(
        state.copyWith(
          responseReserve: reserveDetailRes
        )
      );
    });

    // Informando de las nuevas reservas realizadas en un viaje
    on<EmitNewReserveRequestSocketIO>((event, emit) async {
      print('Emitiendo la creación de una reserva de un viaje >>>>>>>>>>>>>>>>>>>>>');

      AuthResponse? authResponse = await authUseCases.getUserSession.run();
      
      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Passenger Trip Available Detail: ${authResponse.user?.idUser}');

        if(socketIOBloc.state.socket != null) {
          print('Emitiendo');
          socketIOBloc.state.socket?.emit('new_reserve_trip', {
            'id_passenger_request': authResponse.user?.idUser
          });
        }
      } else {
        print('******************* Passenger Trip Available Detail Emit Socket - AuthResponse es Null *******************');
      }
    });

    // Reseteo los valores del State al ejecutar una reserva con Exito
    on<ResetState>((event, emit) {
      print('reseteo');
      emit(const TripAvailableDetailState()); // Emitimos el estado inicial limpio.
    });
  }

  // Opcion 2 que anda el controller **********************************************    
  // Completer<GoogleMapController> get mapControllerCompleter => _mapControllerCompleter;
  // Opcion 2 que anda el controller **********************************************    

  Future<void> setMapController(GoogleMapController controller) async {
    // Opcion 2 que anda el controller **********************************************    
    // if (!_mapControllerCompleter.isCompleted) {
    //   print('Completando el controlador del mapa');
    //   _mapControllerCompleter.complete(controller);
    // } 
    // Opcion 2 que anda el controller **********************************************

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
        northeast: LatLng(destination.latitude, pickUp.longitude)
      );
    } else if (pickUp.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, pickUp.longitude),
        northeast: LatLng(pickUp.latitude, destination.longitude)
      );
    } else {
      bounds = LatLngBounds(southwest: pickUp, northeast: destination);
    }

    return bounds;
  }
}