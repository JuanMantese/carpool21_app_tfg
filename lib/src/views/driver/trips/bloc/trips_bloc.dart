// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_event.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {

  AuthUseCases authUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;

  TripsBloc(
    this.authUseCases,
    this.driverTripRequestsUseCases,
    this.socketUseCases, 
    this.socketIOBloc
  ): super(const TripsState()) {

  
    // final TripsAll exampleTripsAll = TripsAll(
    //   // currentTrip: TripDetail(
    //   //   idTrip: 1,
    //   //   idDriver: 1,
    //   //   driver: Driver(
    //   //     name: 'Carlos',
    //   //     lastName: 'Perez',
    //   //     phone: '1234567890',
    //   //     photo: 'https://example.com/photo.jpg',
    //   //   ),
    //   //   pickupNeighborhood: 'Centro',
    //   //   pickupText: '789 Oak St',
    //   //   pickupLat: 37.7749,
    //   //   pickupLng: -122.4294,
    //   //   destinationNeighborhood: 'Campus Universitario',
    //   //   destinationText: '123 Pine St',
    //   //   destinationLat: 37.7949,
    //   //   destinationLng: -122.4194,
    //   //   availableSeats: 2,
    //   //   departureTime: '2024-06-15T18:30:00Z',
    //   //   distance: 12.0,
    //   //   timeDifference: 20,
    //   //   compensation: 25.0,
    //   //   vehicle: CarInfo(
    //   //     brand: 'Honda',
    //   //     model: 'Civic',
    //   //     patent: '123456',
    //   //     color: 'red',
    //   //     nroGreenCard: '1234',
    //   //     year: 2023,
    //   //   ),
    //   //   observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
    //   //   reservations: [
    //   //     Reservations(
    //   //       idReservation: 1,
    //   //       isPaid: true, 
    //   //       passenger: Passenger(
    //   //         idUser: 1, 
    //   //         name: 'Julian', 
    //   //         lastName: 'Mantese',
    //   //         phone: '2517872662'
    //   //       )
    //   //     ),
    //   //     Reservations(
    //   //       idReservation: 2, 
    //   //       isPaid: true, 
    //   //       passenger: Passenger(
    //   //         idUser: 2,
    //   //         name: 'Daniel', 
    //   //         lastName: 'Mantese',
    //   //         phone: '3517872662'
    //   //       )
    //   //     ),
    //   //   ]
    //   // ),
    //   futureTrips: [
    //     TripDetail(
    //       idTrip: 2,
    //       idDriver: 2,
    //       driver: Driver(
    //         name: 'Ana',
    //         lastName: 'Gomez',
    //         phone: '0987654321',
    //         photo: 'https://example.com/photo2.jpg',
    //       ),
    //       pickupNeighborhood: 'Norte',
    //       pickupText: '456 Maple St',
    //       pickupLat: 37.8049,
    //       pickupLng: -122.4094,
    //       destinationNeighborhood: 'Estadio',
    //       destinationText: '456 Elm St',
    //       destinationLat: 37.8149,
    //       destinationLng: -122.3994,
    //       availableSeats: 3,
    //       departureTime: '2024-06-15T19:00:00Z',
    //       distance: 15.0,
    //       timeDifference: 25,
    //       compensation: 30.0,
    //       vehicle: CarInfo(
    //         brand: 'Toyota',
    //         model: 'Corolla',
    //         patent: '654321',
    //         color: 'blue',
    //         nroGreenCard: '5678',
    //         year: 2022,
    //       ),
    //       observations: 'Encuentro en la entrada principal del estadio',
    //       reservations: [
    //       Reservations(
    //         idReservation: 1,
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 1, 
    //           name: 'Julian', 
    //           lastName: 'Mantese',
    //           phone: '2517872662'
    //         )
    //       ),
    //       Reservations(
    //         idReservation: 2, 
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 2,
    //           name: 'Daniel', 
    //           lastName: 'Mantese',
    //           phone: '3517872662'
    //         )
    //       ),
    //     ]
    //     ),
    //     TripDetail(
    //       idTrip: 2,
    //       idDriver: 2,
    //       driver: Driver(
    //         name: 'Ana',
    //         lastName: 'Gomez',
    //         phone: '0987654321',
    //         photo: 'https://example.com/photo2.jpg',
    //       ),
    //       pickupNeighborhood: 'Norte',
    //       pickupText: '456 Maple St',
    //       pickupLat: 37.8049,
    //       pickupLng: -122.4094,
    //       destinationNeighborhood: 'Estadio',
    //       destinationText: '456 Elm St',
    //       destinationLat: 37.8149,
    //       destinationLng: -122.3994,
    //       availableSeats: 3,
    //       departureTime: '2024-06-15T19:00:00Z',
    //       distance: 15.0,
    //       timeDifference: 25,
    //       compensation: 30.0,
    //       vehicle: CarInfo(
    //         brand: 'Toyota',
    //         model: 'Corolla',
    //         patent: '654321',
    //         color: 'blue',
    //         nroGreenCard: '5678',
    //         year: 2022,
    //       ),
    //       observations: 'Encuentro en la entrada principal del estadio',
    //       reservations: [
    //       Reservations(
    //         idReservation: 1,
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 1, 
    //           name: 'Julian', 
    //           lastName: 'Mantese',
    //           phone: '2517872662'
    //         )
    //       )
    //     ]
    //     ),
    //     TripDetail(
    //       idTrip: 2,
    //       idDriver: 2,
    //       driver: Driver(
    //         name: 'Ana',
    //         lastName: 'Gomez',
    //         phone: '0987654321',
    //         photo: 'https://example.com/photo2.jpg',
    //       ),
    //       pickupNeighborhood: 'Norte',
    //       pickupText: '456 Maple St',
    //       pickupLat: 37.8049,
    //       pickupLng: -122.4094,
    //       destinationNeighborhood: 'Estadio',
    //       destinationText: '456 Elm St',
    //       destinationLat: 37.8149,
    //       destinationLng: -122.3994,
    //       availableSeats: 3,
    //       departureTime: '2024-06-15T19:00:00Z',
    //       distance: 15.0,
    //       timeDifference: 25,
    //       compensation: 30.0,
    //       vehicle: CarInfo(
    //         brand: 'Toyota',
    //         model: 'Corolla',
    //         patent: '654321',
    //         color: 'blue',
    //         nroGreenCard: '5678',
    //         year: 2022,
    //       ),
    //       observations: 'Encuentro en la entrada principal del estadio',
    //       reservations: [
    //       Reservations(
    //         idReservation: 1,
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 1, 
    //           name: 'Julian', 
    //           lastName: 'Mantese',
    //           phone: '2517872662'
    //         )
    //       ),
    //     ]
    //     ),
    //     TripDetail(
    //       idTrip: 2,
    //       idDriver: 2,
    //       driver: Driver(
    //         name: 'Ana',
    //         lastName: 'Gomez',
    //         phone: '0987654321',
    //         photo: 'https://example.com/photo2.jpg',
    //       ),
    //       pickupNeighborhood: 'Norte',
    //       pickupText: '456 Maple St',
    //       pickupLat: 37.8049,
    //       pickupLng: -122.4094,
    //       destinationNeighborhood: 'Estadio',
    //       destinationText: '456 Elm St',
    //       destinationLat: 37.8149,
    //       destinationLng: -122.3994,
    //       availableSeats: 3,
    //       departureTime: '2024-06-15T19:00:00Z',
    //       distance: 15.0,
    //       timeDifference: 25,
    //       compensation: 30.0,
    //       vehicle: CarInfo(
    //         brand: 'Toyota',
    //         model: 'Corolla',
    //         patent: '654321',
    //         color: 'blue',
    //         nroGreenCard: '5678',
    //         year: 2022,
    //       ),
    //       observations: 'Encuentro en la entrada principal del estadio',
    //       reservations: [
    //       Reservations(
    //         idReservation: 1,
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 1, 
    //           name: 'Julian', 
    //           lastName: 'Mantese',
    //           phone: '2517872662'
    //         )
    //       )
    //     ]
    //     ),
    //   ],
    //   pastTrips: [
    //     TripDetail(
    //       idTrip: 3,
    //       idDriver: 3,
    //       driver: Driver(
    //         name: 'Luis',
    //         lastName: 'Martinez',
    //         phone: '1122334455',
    //         photo: 'https://example.com/photo3.jpg',
    //       ),
    //       pickupNeighborhood: 'Sur',
    //       pickupText: '321 Birch St',
    //       pickupLat: 37.7849,
    //       pickupLng: -122.4394,
    //       destinationNeighborhood: 'Parque',
    //       destinationText: '789 Cedar St',
    //       destinationLat: 37.7549,
    //       destinationLng: -122.4694,
    //       availableSeats: 1,
    //       departureTime: '2024-06-15T17:00:00Z',
    //       distance: 10.0,
    //       timeDifference: 15,
    //       compensation: 20.0,
    //       vehicle: CarInfo(
    //         brand: 'Ford',
    //         model: 'Focus',
    //         patent: '789012',
    //         color: 'green',
    //         nroGreenCard: '91011',
    //         year: 2021,
    //       ),
    //       observations: 'Encuentro en la entrada del parque',
    //       reservations: [
    //       Reservations(
    //         idReservation: 1,
    //         isPaid: true, 
    //         passenger: Passenger(
    //           idUser: 1, 
    //           name: 'Julian', 
    //           lastName: 'Mantese',
    //           phone: '2517872662'
    //         )
    //       ),
    //     ]
    //     ),
    //   ],
    // );

    on<GetTripsAll>((event, emit) async {
      print('GetTripsAll ---------------------');
      print('Estado actual antes de actualizar: ${state.tripsAll}');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );
      
      // Recuperando las reservas del Pasajero
      Resource<TripsAll> tripsAllRes = await driverTripRequestsUseCases.getDriverTripsUseCase.run();
      print('Response - $tripsAllRes');
      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          response: tripsAllRes,
        )
      );

      if (tripsAllRes is Success<TripsAll>) {
        print('Estado actualizado con viajes disponibles: ${tripsAllRes.data}');

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        add(ListenTripsAllSocketIO());

        emit(
          state.copyWith(
            tripsAll: tripsAllRes.data,
          )
        );
      }
    });

    // Escuchamos los nuevos Viajes disponibles del conductor
    on<ListenTripsAllSocketIO>((event, emit) async {
      print('Escuchando nuevos viajes disponibles del conductor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(socketIOBloc.state.socket);
      print(socketIOBloc.state.socket?.connected);

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Driver Trips: ${authResponse.user?.idUser}');

        if (socketIOBloc.state.socket != null && socketIOBloc.state.socket!.connected) {
          print('Entramos a la escucha');
          
          socketIOBloc.state.socket?.on('trips_all_changed_notification/${authResponse.user?.idUser}', (data) async {
            print('Cambios detectados en los Viajes - Socket IO');
            print(data);

            // Actualizando la pantalla con los viajes disponibles 
            add(GetTripsAll());
          });
        }
      } else {
        print('******************* Driver Trips - AuthResponse es Null *******************');
      }
    });

  }
}
