import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserveUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_event.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerHomeViewBloc extends Bloc<PassengerHomeViewEvent, PassengerHomeViewState> {

  AuthUseCases authUseCases;
  ReserveUseCases reserveUseCases;

  PassengerHomeViewBloc(this.authUseCases, this.reserveUseCases): super(PassengerHomeViewState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(
        state.copyWith(
          pageIndex: event.pageIndex, 
        )
      );

      // final currentState = state;
      // if (currentState is PassengerHomeSuccess) {
      //   emit(currentState.copyWith(pageIndex: event.pageIndex));
      // } else {
      //   emit(PassengerHomeInitial());
      // }
    });

    // on<Logout>((event, emit) async {
    //   await authUseCases.logout.run();
    // });


    // Usuario de prueba - Logica para obtener todos los datos del usuario
    // void _setTestUser(GetUserInfo event, Emitter<PassengerHomeViewState> emit) {
    //   final User testUser = User(
    //     idUser: 1,
    //     name: 'Juan',
    //     lastName: 'Mantese',
    //     studentFile: 'SOF01669',
    //     dni: 12345678,
    //     phone: 3517872662,
    //     address: '123 Calle Falsa',
    //     email: 'juan.mantese@example.com',
    //     password: 'password123',
    //     passwordConfirm: 'password123',
    //     contactName: 'Julian',
    //     contactLastName: 'Mantese',
    //     contactPhone: 3513751312,
    //     photoUser: 'lib/assets/img/profile-icon.png',
    //     notificationToken: null,
    //     roles: [
    //       Role(
    //         idRole: "ADMIN",
    //         name: "Administrador",
    //         route: "/roles/admin",
    //       ),
    //       Role(
    //         idRole: "PASSENGER",
    //         name: "Pasajero",
    //         route: "/roles/passenger",
    //       ),
    //     ],
    //   );

    //   emit(state.copyWith(
    //     roles: testUser.roles?.map((role) => role).toList(),
    //     currentUser: testUser,
    //     userService: event.userService, 
    //   ));
    // }

    // void _setCurrentReserve(GetCurrentReserve event, Emitter<PassengerHomeViewState> emit) {
    //   final exampleCurrentReserve = TripDetail(
    //     idTrip: 1,
    //     idDriver: 1,
    //     driver: Driver(
    //       name: 'Carlos',
    //       lastName: 'Perez',
    //       phone: '1234567890',
    //       photo: 'https://example.com/photo.jpg',
    //     ),
    //     pickupNeighborhood: 'Centro',
    //     pickupText: '789 Oak St',
    //     pickupLat: 37.7749,
    //     pickupLng: -122.4294,
    //     destinationNeighborhood: 'Campus Universitario',
    //     destinationText: '123 Pine St',
    //     destinationLat: 37.7949,
    //     destinationLng: -122.4194,
    //     availableSeats: 2,
    //     departureTime: '2024-06-15T18:30:00Z',
    //     distance: 12.0,
    //     timeDifference: 20,
    //     compensation: 25.0,
    //     vehicle: CarInfo(
    //       brand: 'Honda',
    //       model: 'Civic',
    //       patent: '123456',
    //       color: 'red',
    //       nroGreenCard: '1234',
    //       year: 2023,
    //     ),
    //     observations: 'Encuentro en el Patio Olmos sobre la puerta de entrada que da a Bvd Illia',
    //     reservations: [
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
    //   );

    //   print('Cambiando los datos de la reserva');
    //   emit(state.copyWith(
    //     currentReserve: exampleCurrentReserve,
    //   ));
    // }


    on<GetUserInfo>((event, emit) async {
      print('GetUserInfo Home Passenger --------------------');
      emit(state.copyWith(responseStatus: PassengerHomeViewStatus.loading));

      try {
        AuthResponse? authResponse = await authUseCases.getUserSession.run();

        if (authResponse != null && authResponse.user != null) {
          print('Datos del usuario obtenidos - Passenger');
          print(authResponse.toJson());
          
          List<Role> roles = authResponse.user!.roles?.map((role) => role).toList() ?? [];
          print(roles[0]);
          emit(
            state.copyWith(
              responseStatus: PassengerHomeViewStatus.success,
              roles: roles,
              currentUser: authResponse.user,
              userService: event.userService, 
            )
          );
        } else {
          print('Passenger Home - AuthResponse es Null');
          emit(state.copyWith(responseStatus: PassengerHomeViewStatus.error, errorMessage: 'No se lograron obtener los datos del usuario'));
        }
      } catch (error) {
        print('Error: $error');
        emit(state.copyWith(responseStatus: PassengerHomeViewStatus.error, errorMessage: 'Ocurrió un error al obtener la información'));
      }
    });

    on<GetCurrentReserve>((event, emit) async {
      print('GetCurrentReserve Home Passenger ---------------');
      emit(state.copyWith(responseStatus: PassengerHomeViewStatus.loading));

      try {
        // Recuperando las reservas del Pasajero
        Resource<dynamic> reservesAllres = await reserveUseCases.getAllReservesUseCase.run();
        print('Response Reserves All: $reservesAllres');

        if (reservesAllres is Success) {
          ReservesAll reservesAll = reservesAllres.data;
          print(reservesAll.toJson());
          emit(
            state.copyWith(
              responseStatus: PassengerHomeViewStatus.success,
              reservesAll: reservesAll,
            )
          );
        } else if (reservesAllres is ErrorData) {
          emit(state.copyWith(responseStatus: PassengerHomeViewStatus.error, errorMessage: reservesAllres.message));
          return;
        } else {
          // _setCurrentReserve(event, emit); // Array de prueba
          print('GetCurrentReserve - ErrorData');
          emit(state.copyWith(responseStatus: PassengerHomeViewStatus.error, errorMessage: 'No se lograron obtener los datos de la reserva'));
        }
      } catch (error) {
        print('Error GetCurrentReserve: $error');
        emit(state.copyWith(responseStatus: PassengerHomeViewStatus.error, errorMessage: 'Ocurrió un error al obtener la información'));
      }
    });
  }
}