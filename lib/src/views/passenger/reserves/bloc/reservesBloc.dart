

import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserveUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reservesEvent.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reservesState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservesBloc extends Bloc<ReservesEvent, ReservesState> {


  ReserveUseCases reserveUseCases;

  ReservesBloc(
    this.reserveUseCases,
  ): super(const ReservesState()) {

    void _setTestReserves(GetReservesAll event, Emitter<ReservesState> emit) {
      final ReservesAll exampleReservesAll = ReservesAll(
        // currentReserve: 
        //   ReserveDetail(
        //     idReservation: 1,
        //     isPaid: true,
        //     driver: Driver(
        //       name: 'Carlos',
        //       lastName: 'Perez',
        //       phone: '1234567890',
        //       photo: 'https://example.com/photo.jpg',
        //     ),
        //     tripRequest: TripDetail(
        //       idTrip: 64,
        //       idDriver: 5,
        //       pickupNeighborhood: 'Centro',
        //       pickupText: '789 Oak St',
        //       pickupLat: 37.7749,
        //       pickupLng: -122.4294,
        //       destinationNeighborhood: 'Campus Universitario',
        //       destinationText: '123 Pine St',
        //       destinationLat: 37.7949,
        //       destinationLng: -122.4194,
        //       availableSeats: 2,
        //       departureTime: '2024-06-15T18:30:00Z',
        //       distance: 12.0,
        //       timeDifference: 20,
        //       compensation: 25.0,
        //       observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
        //       vehicle: CarInfo(
        //         brand: 'Honda',
        //         model: 'Civic',
        //         patent: '123456',
        //         color: 'red',
        //         nroGreenCard: '1234',
        //         year: 2023,
        //       ),
        //     )
        //   ),
        futureReservations: [
          ReserveDetail(
            idReservation: 1,
            isPaid: true,
            driver: Driver(
              name: 'Carlos',
              lastName: 'Perez',
              phone: '1234567890',
              photo: 'https://example.com/photo.jpg',
            ),
            tripRequest: TripDetail(
              idTrip: 64,
              idDriver: 5,
              pickupNeighborhood: 'Centro',
              pickupText: '789 Oak St',
              pickupLat: 37.7749,
              pickupLng: -122.4294,
              destinationNeighborhood: 'Campus Universitario',
              destinationText: '123 Pine St',
              destinationLat: 37.7949,
              destinationLng: -122.4194,
              availableSeats: 2,
              departureTime: '2024-06-15T18:30:00Z',
              distance: 12.0,
              timeDifference: 20,
              compensation: 25.0,
              observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
              vehicle: CarInfo(
                brand: 'Honda',
                model: 'Civic',
                patent: '123456',
                color: 'red',
                nroGreenCard: '1234',
                year: 2023,
              ),
            )
          ),
          ReserveDetail(
              idReservation: 1,
            isPaid: true,
            driver: Driver(
              name: 'Carlos',
              lastName: 'Perez',
              phone: '1234567890',
              photo: 'https://example.com/photo.jpg',
            ),
            tripRequest: TripDetail(
              idTrip: 64,
              idDriver: 5,
              pickupNeighborhood: 'Centro',
              pickupText: '789 Oak St',
              pickupLat: 37.7749,
              pickupLng: -122.4294,
              destinationNeighborhood: 'Campus Universitario',
              destinationText: '123 Pine St',
              destinationLat: 37.7949,
              destinationLng: -122.4194,
              availableSeats: 2,
              departureTime: '2024-06-15T18:30:00Z',
              distance: 12.0,
              timeDifference: 20,
              compensation: 25.0,
              observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
              vehicle: CarInfo(
                brand: 'Honda',
                model: 'Civic',
                patent: '123456',
                color: 'red',
                nroGreenCard: '1234',
                year: 2023,
              ),
            )
          ),
          ReserveDetail(
             idReservation: 1,
            isPaid: true,
            driver: Driver(
              name: 'Carlos',
              lastName: 'Perez',
              phone: '1234567890',
              photo: 'https://example.com/photo.jpg',
            ),
            tripRequest: TripDetail(
              idTrip: 64,
              idDriver: 5,
              pickupNeighborhood: 'Centro',
              pickupText: '789 Oak St',
              pickupLat: 37.7749,
              pickupLng: -122.4294,
              destinationNeighborhood: 'Campus Universitario',
              destinationText: '123 Pine St',
              destinationLat: 37.7949,
              destinationLng: -122.4194,
              availableSeats: 2,
              departureTime: '2024-06-15T18:30:00Z',
              distance: 12.0,
              timeDifference: 20,
              compensation: 25.0,
              observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
              vehicle: CarInfo(
                brand: 'Honda',
                model: 'Civic',
                patent: '123456',
                color: 'red',
                nroGreenCard: '1234',
                year: 2023,
              ),
            )
          ),
          ReserveDetail(
            idReservation: 1,
            isPaid: true,
            driver: Driver(
              name: 'Carlos',
              lastName: 'Perez',
              phone: '1234567890',
              photo: 'https://example.com/photo.jpg',
            ),
            tripRequest: TripDetail(
              idTrip: 64,
              idDriver: 5,
              pickupNeighborhood: 'Centro',
              pickupText: '789 Oak St',
              pickupLat: 37.7749,
              pickupLng: -122.4294,
              destinationNeighborhood: 'Campus Universitario',
              destinationText: '123 Pine St',
              destinationLat: 37.7949,
              destinationLng: -122.4194,
              availableSeats: 2,
              departureTime: '2024-06-15T18:30:00Z',
              distance: 12.0,
              timeDifference: 20,
              compensation: 25.0,
              observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
              vehicle: CarInfo(
                brand: 'Honda',
                model: 'Civic',
                patent: '123456',
                color: 'red',
                nroGreenCard: '1234',
                year: 2023,
              ),
            )
          ),
        ],
        pastReservations: [
          ReserveDetail(
            idReservation: 1,
            isPaid: true,
            driver: Driver(
              name: 'Carlos',
              lastName: 'Perez',
              phone: '1234567890',
              photo: 'https://example.com/photo.jpg',
            ),
            tripRequest: TripDetail(
              idTrip: 64,
              idDriver: 5,
              pickupNeighborhood: 'Centro',
              pickupText: '789 Oak St',
              pickupLat: 37.7749,
              pickupLng: -122.4294,
              destinationNeighborhood: 'Campus Universitario',
              destinationText: '123 Pine St',
              destinationLat: 37.7949,
              destinationLng: -122.4194,
              availableSeats: 2,
              departureTime: '2024-06-15T18:30:00Z',
              distance: 12.0,
              timeDifference: 20,
              compensation: 25.0,
              observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
              vehicle: CarInfo(
                brand: 'Honda',
                model: 'Civic',
                patent: '123456',
                color: 'red',
                nroGreenCard: '1234',
                year: 2023,
              ),
            )
          ),
        ]
      );

      emit(state.copyWith(
        testingReservesAll: exampleReservesAll,
      ));
    }

    on<GetReservesAll>((event, emit) async {
      print('GetReservesAll');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );
      // Recuperando las reservas del Pasajero
      // Resource<ReservesAll> response = await reserveUseCases.getAllReservesUseCase.run();
      // print('Response - $response');
      // emit(
      //   state.copyWith(
      //     response: response,
      //   )
      // );

      // DELETE - Testeando con un objeto de prueba
      print('Usando el Array de prueba');
      _setTestReserves(event, emit);
    }); 

  }
}
