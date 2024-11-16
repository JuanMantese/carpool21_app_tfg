
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/driversPositionUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsAvailableBloc extends Bloc<TripsAvailableEvent, TripsAvailableState> {

  AuthUseCases authUseCases;
  DriversPositionUseCases driversPositionUseCases;

  DriverTripRequestsUseCases driverTripRequestsUseCases;

  TripsAvailableBloc(
    this.authUseCases,
    this.driversPositionUseCases,
    this.driverTripRequestsUseCases
  ): super(TripsAvailableState()) {

    // DELETE - Testeando con un objeto de prueba
    void _setTestPassengerRequests(GetTripsAvailable event, Emitter<TripsAvailableState> emit) {
      List<TripDetail> toTripsAvailable = [
        TripDetail(
          idTrip: 1,
          idDriver: 101,
          pickupNeighborhood: 'Centro',
          pickupText: "Patio Olmos Shopping, Córdoba, Córdoba Capital, Argentina",
          pickupLat: 37.7749,
          pickupLng: -122.4194,
          destinationNeighborhood: 'Campus Universitario',
          destinationText: "Universidad Siglo 21, De los Latinos, Córdoba, Córdoba Province, Argentina",
          destinationLat: 37.7849,
          destinationLng: -122.4094,
          availableSeats: 3,
          departureTime: "2024-06-15T08:00:00Z",
          // pickupPosition: Position(x: 37.7749, y: -122.4194),
          // destinationPosition: Position(x: 37.7849, y: -122.4094),
          distance: 10.0,
          timeDifference: 15,
          vehicle: CarInfo(brand: "Toyota", model: "Corolla", patent: '123456', color: 'red', nroGreenCard: '1234', year: 2024),
          compensation: 1000.0,
        ),
        TripDetail(
          idTrip: 2,
          idDriver: 102,
          pickupNeighborhood: 'Centro',
          pickupText: "789 Oak St",
          pickupLat: 37.7749,
          pickupLng: -122.4294,
          destinationNeighborhood: 'Campus Universitario',
          destinationText: "123 Pine St",
          destinationLat: 37.7949,
          destinationLng: -122.4194,
          availableSeats: 2,
          departureTime: "2024-06-15T09:00:00Z",
          // pickupPosition: Position(x: 37.7749, y: -122.4294),
          // destinationPosition: Position(x: 37.7949, y: -122.4194),
          distance: 12.0,
          timeDifference: 20,
          vehicle: CarInfo(brand: "Honda", model: "Civic", patent: '123456', color: 'red', nroGreenCard: '1234', year: 2023),
          compensation: 1000.0,
        ),
        TripDetail(
          idTrip: 3,
          idDriver: 103,
          pickupNeighborhood: 'Centro',
          pickupText: "321 Maple St",
          pickupLat: 37.7649,
          pickupLng: -122.4094,
          destinationNeighborhood: 'Campus Universitario',
          destinationText: "654 Cedar St",
          destinationLat: 37.7749,
          destinationLng: -122.3994,
          availableSeats: 4,
          departureTime: "2024-06-15T10:00:00Z",
          // pickupPosition: Position(x: 37.7649, y: -122.4094),
          // destinationPosition: Position(x: 37.7749, y: -122.3994),
          distance: 8.0,
          timeDifference: 10,
          vehicle: CarInfo(brand: "Ford", model: "Focus", patent: '123456', color: 'red', nroGreenCard: '1234', year: 2025),
          compensation: 1000.0,
        ),
      ];

      emit(state.copyWith(
        availableTrips: toTripsAvailable,
      ));
    }

    on<GetNearbyTripRequest>((event, emit) async {
      // AuthResponse authResponse = await authUseCases.getUserSession.run();
      // Resource driverPositionResponse = await driversPositionUseCases.getDriverPosition.run(authResponse.user.id ?? 1);

      // emit(
      //   state.copyWith(
      //     response: Loading(),
      //   )
      // );

      // if (driverPositionResponse is Success) {
      //   final driverPosition = driverPositionResponse.data as DriverPosition;
      //   Resource<List<PassengerRequest>> response = await passengerRequestsUseCases.getNearbyTripRequestUseCase.run(driverPosition.lat, driverPosition.lng);
      //   emit(
      //     state.copyWith(
      //       response: response,
      //     )
      //   );
      // }

      // DELETE - Testeando con un objeto de prueba
      print('Usando el Array de prueba');
      // _setTestPassengerRequests(event, emit);

    });

    on<GetTripsAvailable>((event, emit) async {
      print('GetTripsAvailable ---------------------');
      Success<List<TripDetail>> availableTripsRes = await driverTripRequestsUseCases.getAllTripsUseCase.run();
      print(availableTripsRes);
      emit(
        state.copyWith(
          response: Loading(),
        )
      );

      if (availableTripsRes is Success) {
        List<TripDetail> availableTrips = availableTripsRes.data;

        emit(
          state.copyWith(
            availableTrips: availableTrips,
          )
        );
      }

      // DELETE - Testeando con un objeto de prueba
      print('Usando el Array de prueba');
      // _setTestPassengerRequests(event, emit);

    });

  }
}