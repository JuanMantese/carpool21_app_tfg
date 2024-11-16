import 'dart:async';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocationUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserveUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReserveDetailBloc extends Bloc<ReserveDetailEvent, ReserveDetailState> {

  GeolocationUseCases geolocationUseCases;
  ReserveUseCases reserveUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;

  // Constructor
  ReserveDetailBloc(this.geolocationUseCases, this.reserveUseCases, this.driverTripRequestsUseCases): super(ReserveDetailState()) {
    
    void _setTestReserveDetail(GetReserveDetail event, Emitter<ReserveDetailState> emit) {
      // final ReserveDetail testReserveDetail = ReserveDetail(
      //   idTrip: 1,
      //   idDriver: 1,
      //   driver: Driver(
      //     name: 'Carlos',
      //     lastName: 'Perez',
      //     phone: '1234567890',
      //   ),
      //   pickupNeighborhood: 'Patio Olmos Shopping',
      //   pickupText: "Av. Vélez Sarsfield 361, Córdoba",
      //   pickupLat: -31.4198807,
      //   pickupLng: -64.1908178,
      //   destinationNeighborhood: 'Campus Universitario',
      //   destinationText: "Universidad Siglo 21, De los Latinos, Córdoba, Córdoba Province, Argentina",
      //   destinationLat: -31.322187,
      //   destinationLng: -64.2219203,
      //   availableSeats: 2,
      //   departureTime: "18:30",
      //   distance: 12.0,
      //   timeDifference: 20,
      //   vehicle: CarInfo(brand: "Honda", model: "Civic", patent: '123456', color: 'red', nroGreenCard: '1234', year: 2023),
      //   compensation: 25.0,
      //   observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
      //   reservations: [
      //     Reservations(
      //       idReservation: 1,
      //       isPaid: true, 
      //       passenger: Passenger(
      //         idUser: 1, 
      //         name: 'Julian', 
      //         lastName: 'Mantese',
      //         phone: '2517872662'
      //       )
      //     ),
      //     Reservations(
      //       idReservation: 2, 
      //       isPaid: true, 
      //       passenger: Passenger(
      //         idUser: 2,
      //         name: 'Daniel', 
      //         lastName: 'Mantese',
      //         phone: '3517872662'
      //       )
      //     ),
      //   ]
      // );

      // emit(state.copyWith(
      //   reserveDetail: testTripDetail,
      //   pickUpLatLng: LatLng(testTripDetail.pickupLat, testTripDetail.pickupLng),
      //   destinationLatLng: LatLng(testTripDetail.destinationLat, testTripDetail.destinationLng)
      // ));
    }

    on<GetReserveDetail>((event, emit) async {
      print('Aca entramos en GetTripDetail');

      try {
        // Realizar la consulta para traer el detalle de un viaje
        Success<ReserveDetail> reserveDetailRes = await reserveUseCases.getReserveDetailUseCase.run(event.idReserve);
        if (reserveDetailRes is Success) {
          ReserveDetail reserveDetail = reserveDetailRes.data;
          print('ACA: ${reserveDetail.toJson()}');
          emit(
            state.copyWith(
              reserveDetail: reserveDetail,
              pickUpLatLng: LatLng(reserveDetail.tripRequest.pickupLat, reserveDetail.tripRequest.pickupLng),
              destinationLatLng: LatLng(reserveDetail.tripRequest.destinationLat, reserveDetail.tripRequest.destinationLng)
            )
          );
        } else {
          print('======================== GetReserveDetail NO ENTRO ========================');
          _setTestReserveDetail(event, emit);
        }
      } catch (error) {
        print('======================== Error GetTripDetail $error ========================');
        _setTestReserveDetail(event, emit);
      }

      print('======================== Usando _setTestReserveDetail ========================');
      _setTestReserveDetail(event, emit);
    }); 

    on<ReserveDetailInitMap>((event, emit) async {
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
      print(state.controller);
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