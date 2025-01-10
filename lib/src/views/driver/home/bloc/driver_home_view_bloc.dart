import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_event.dart';

import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeViewBloc extends Bloc<DriverHomeViewEvent, DriverHomeViewState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;

  DriverHomeViewBloc(this.authUseCases, this.carInfoUseCases, this.driverTripRequestsUseCases): super(DriverHomeViewState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(
        state.copyWith(
          pageIndex: event.pageIndex
        )
      );
    });

    // on<Logout>((event, emit) async {
    //   await authUseCases.logout.run();
    // });


    // Usuario de prueba - Logica para obtener todos los datos del usuario
    // void _setTestUser(GetUserInfo event, Emitter<DriverHomeState> emit) {
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

    on<GetUserInfo>((event, emit) async {
      print('GetUserInfo Home Driver --------------------');
      emit(state.copyWith(responseStatus: DriverHomeViewStatus.loading));

      List<CarInfo>? carList;
      TripsAll? driverTripAll;
      
      try {
        // Obteniendo los vehiculos del Driver
        Resource<dynamic> response = await carInfoUseCases.getCarList.run();

        if (response is Success) {
          print('Vehiculos obtenidos');
          carList = response.data as List<CarInfo>;
        } else {
          print('No se lograron obtener los vehiculos');
          emit(state.copyWith(responseStatus: DriverHomeViewStatus.error, errorMessage: 'No se lograron obtener los vehiculos'));
        }
      
        // Realizar la consulta para traer el detalle de un viaje
        Resource<dynamic> driverTripAllRes = await driverTripRequestsUseCases.getDriverTripsUseCase.run();
        
        if (driverTripAllRes is Success) {
          driverTripAll = driverTripAllRes.data as TripsAll;
          print('Viajes obtenidos: ${driverTripAll.toJson()}');
        } else if (driverTripAllRes is ErrorData) {
          emit(state.copyWith(responseStatus: DriverHomeViewStatus.error, errorMessage: driverTripAllRes.message));
          return;
        } else {
          emit(state.copyWith(responseStatus: DriverHomeViewStatus.error, errorMessage: 'Error desconocido al obtener los detalles del viaje'));
          return;
        }

        // Obteniendo los datos del Driver
        AuthResponse? authResponse = await authUseCases.getUserSession.run();

        if (authResponse != null && authResponse.user != null) {
          print('Datos del usuario obtenidos');
          
          User userData = authResponse.user!;
          List<Role> roles = authResponse.user!.roles?.map((role) => role).toList() ?? [];

          emit(
            state.copyWith(
              responseStatus: DriverHomeViewStatus.success,
              user: userData,
              roles: roles,
              currentUser: authResponse.user,
              userService: event.userService,
              carList: carList,
              driverTripAll: driverTripAll
            )
          );
        } else {
          print('Driver Home - AuthResponse es Null');
          emit(state.copyWith(responseStatus: DriverHomeViewStatus.error, errorMessage: 'No se lograron obtener los datos del usuario'));
        }
      } catch (error) {
        print('Error: $error');
        emit(state.copyWith(responseStatus: DriverHomeViewStatus.error, errorMessage: 'Ocurrió un error al obtener la información'));
      }
    });
  }
}