import 'dart:async';
import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocationUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserveUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/tripAvailableDetailEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/tripAvailableDetailState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TripAvailableDetailBloc extends Bloc<TripAvailableDetailEvent, TripAvailableDetailState> {

  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  ReserveUseCases reserveUseCases;
  // AuthUseCases authUseCases;
  
  TripAvailableDetailBloc(this.geolocationUseCases, this.driverTripRequestsUseCases, this.reserveUseCases): super(TripAvailableDetailState()) {
  
    on<TripAvailableDetailInitEvent>((event, emit) async {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();

      emit(
        state.copyWith(
          pickUpText: event.pickUpText,
          pickUpLatLng: event.pickUpLatLng,
          destinationText: event.destinationText,
          destinationLatLng: event.destinationLatLng,
          departureTime: event.departureTime,
          compensation: event.compensation,
          driver: event.driver,
          controller: controller,
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
      print('Entramos a ChangeMapCameraPosition');
      print(event.pickUpLatLng);
      print(event.destinationLatLng);

      try {
        GoogleMapController googleMapController = await state.controller!.future;

        // Calcula los límites usando pickUpLatLng y destinationLatLng
        LatLngBounds bounds = calculateBounds(event.pickUpLatLng, event.destinationLatLng);

        await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    });  

    // Agregando la ruta al mapa
    on<AddPolyline>((event, emit) async {
      // Obteniendo las coordenadas del origen y destino
      List<LatLng> polylineCoordinates = await geolocationUseCases.getPolyline.run(state.pickUpLatLng!, state.destinationLatLng!);

      PolylineId id = PolylineId("MyRoute"); // Id de la ruta
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

    // on<EmitNewPassengerRequestSocketIO>((event, emit) {
    //   if (blocSocketIO.state.socket != null) {
    //     blocSocketIO.state.socket?.emit('new_client_request', {
    //         'id_client_request': event.idClientRequest
    //     });
    //   }
    // });
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