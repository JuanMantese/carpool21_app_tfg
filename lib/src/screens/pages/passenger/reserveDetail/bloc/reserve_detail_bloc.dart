// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReserveDetailBloc extends Bloc<ReserveDetailEvent, ReserveDetailState> {

  GeolocationUseCases geolocationUseCases;
  ReserveUseCases reserveUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  
  // Constructor
  ReserveDetailBloc(
    this.geolocationUseCases, 
    this.reserveUseCases, 
    this.driverTripRequestsUseCases,
  ): super(ReserveDetailState(
    responseGetReserve: Loading(),
  )) {
    
    on<GetReserveDetail>((event, emit) async {
      print('GetReserveDetail ---------------------');

      emit(
        state.copyWith(
          responseGetReserve: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el resultado
      Resource<ReserveDetail> responseReserveDetail = await reserveUseCases.getReserveDetailUseCase.run(event.idReserve);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseGetReserve: responseReserveDetail,
        ),
      );

      if (responseReserveDetail is Success<ReserveDetail>) {
        print('Estado actualizado con los datos de la reserva: ${responseReserveDetail.data}');

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        // add(ListenReserveChangesSocketIO());

        emit(
          state.copyWith(
            pickUpLatLng: LatLng(responseReserveDetail.data.tripRequest.pickupLat, responseReserveDetail.data.tripRequest.pickupLng),
            destinationLatLng: LatLng(responseReserveDetail.data.tripRequest.destinationLat, responseReserveDetail.data.tripRequest.destinationLng)
          )
        );

        // Inicializando el Mapa
        add(InitializeMap());

      } else if (responseReserveDetail is ErrorData<ReserveDetail>) {
        print('Error al obtener los datos de la reserva: ${responseReserveDetail.message}');
      }
    }); 


    on<InitializeMap>((event, emit) async {
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
      add(AddPolyline());
    });

    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition  -------------------------------------');
      print(event.pickUpLatLng);
      print(event.destinationLatLng);

      try {
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

    // Reseteo los valores del State al ejecutar una reserva con Exito
    on<ResetState>((event, emit) {
      print('reseteo');
      emit(const ReserveDetailState()); // Emitimos el estado inicial limpio.
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