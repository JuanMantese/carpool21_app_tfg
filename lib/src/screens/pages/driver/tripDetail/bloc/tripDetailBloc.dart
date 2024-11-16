import 'dart:async';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocationUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailBloc extends Bloc<TripDetailEvent, TripDetailState> {

  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;

  // Constructor
  TripDetailBloc(this.geolocationUseCases, this.driverTripRequestsUseCases): super(TripDetailState()) {
    
    void _setTestTripDetail(GetTripDetail event, Emitter<TripDetailState> emit) {
      final TripDetail testTripDetail = TripDetail(
        idTrip: 1,
        idDriver: 1,
        pickupNeighborhood: 'Centro',
        pickupText: "789 Oak St",
        pickupLat: 37.7749,
        pickupLng: -122.4294,
        destinationNeighborhood: 'Campus Universitario',
        destinationText: "123 Pine St",
        destinationLat: 37.7949,
        destinationLng: -122.4194,
        availableSeats: 2,
        departureTime: "18:30",
        distance: 12.0,
        timeDifference: 20, // Devuelve en minutos
        vehicle: CarInfo(brand: "Honda", model: "Civic", patent: '123456', color: 'red', nroGreenCard: '1234', year: 2023),
        compensation: 25.0,
        observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
        reservations: [
          Reservations(
            idReservation: 1,
            isPaid: true, 
            passenger: Passenger(
              idUser: 1, 
              name: 'Julian', 
              lastName: 'Mantese',
              phone: '2517872662'
            ),
          ),
          Reservations(
            idReservation: 2, 
            isPaid: true, 
            passenger: Passenger(
              idUser: 2,
              name: 'Daniel', 
              lastName: 'Mantese',
              phone: '3517872662'
            )
          ),
        ]

      );

      emit(state.copyWith(
        tripDetail: testTripDetail,
        pickUpLatLng: LatLng(testTripDetail.pickupLat, testTripDetail.pickupLng),
        destinationLatLng: LatLng(testTripDetail.destinationLat, testTripDetail.destinationLng)
      ));
    }

    on<GetTripDetail>((event, emit) async {
      try {
        // Realizar la consulta para traer el detalle de un viaje
        Success<TripDetail> tripDetailRes = await driverTripRequestsUseCases.getTripDetailUseCase.run(event.idTrip);
        print('Aca entramos en GetTripDetail');
        if (tripDetailRes is Success) {
          TripDetail tripDetail = tripDetailRes.data;
          print('ACA: ${tripDetail.toJson()}');
          emit(
            state.copyWith(
              tripDetail: tripDetail,
              pickUpLatLng: LatLng(tripDetail.pickupLat, tripDetail.pickupLng),
              destinationLatLng: LatLng(tripDetail.destinationLat, tripDetail.destinationLng)
            )
          );
        } else {
          print('======================== GetTripDetail NO ENTRO ========================');
          _setTestTripDetail(event, emit);
        }
      } catch (error) {
        print('Error GetTripDetail $error');
        _setTestTripDetail(event, emit);
      }

      print('Usando _setTestTripDetail');
      // _setTestTripDetail(event, emit);
    }); 

    on<TripDetailInitMap>((event, emit) async {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();

       emit(
        state.copyWith(
          controller: controller,
        )
      );
    });

    on<InitializeMap>((event, emit) async {
      print('InitializeMap -------------------------------------');
      print(state.destinationLatLng);

      // Completer<GoogleMapController> controller = Completer<GoogleMapController>();
      
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
          // controller: controller,
          markers: {
            markerPickUp.markerId: markerPickUp,
            markerDestination.markerId: markerDestination,
          }
        )
      );
    });

    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition  -------------------------------------');
      print(event.pickUpLatLng);
      print(event.destinationLatLng);

      try {
        GoogleMapController googleMapController = await state.controller!.future;

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

      // Modificando la posicion de la camara en el mapa
      add(ChangeMapCameraPosition(pickUpLatLng: state.pickUpLatLng!, destinationLatLng: state.destinationLatLng!));
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