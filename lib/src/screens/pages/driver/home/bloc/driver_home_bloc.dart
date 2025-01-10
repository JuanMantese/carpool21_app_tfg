// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/screens/pages/driver/home/bloc/driver_home_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/home/bloc/driver_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;

  DriverHomeBloc(
    this.authUseCases, 
    this.carInfoUseCases, 
    this.driverTripRequestsUseCases
  ): super(const DriverHomeState()) {
    
    // Usuario de prueba
    // ignore: unused_local_variable
    final User testUser = User(
      idUser: 1,
      name: 'Juan',
      lastName: 'Mantese',
      studentFile: 'SOF01669',
      dni: 12345678,
      phone: 3517872662,
      address: '123 Calle Falsa',
      email: 'juan.mantese@example.com',
      password: 'password123',
      passwordConfirm: 'password123',
      contactName: 'Julian',
      contactLastName: 'Mantese',
      contactPhone: 3513751312,
      photoUser: 'lib/assets/img/profile-icon.png',
      notificationToken: null,
      roles: [
        Role(
          idRole: "ADMIN",
          name: "Administrador",
          route: "/roles/admin",
        ),
        Role(
          idRole: "PASSENGER",
          name: "Pasajero",
          route: "/roles/passenger",
        ),
      ],
    );

    // on<ChangeDrawerPage>((event, emit) {
    //   emit(
    //     state.copyWith(
    //       pageIndex: event.pageIndex
    //     )
    //   );
    // });

    // on<Logout>((event, emit) async {
    //   await authUseCases.logout.run();
    // });

    on<GetUserInfo>((event, emit) async {
      print('GetUserInfo Home Driver --------------------');
     
      // Obteniendo los datos del Driver
      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos');
        
        User userData = authResponse.user!;
        print(userData);

        List<Role> roles = authResponse.user!.roles?.map((role) => role).toList() ?? [];

        emit(
          state.copyWith(
            user: userData,
            roles: roles,
            currentUser: authResponse.user,
            userService: event.userService,
          )
        );
      } else {
        print('No se lograron obtener los datos del usuario - GetUserInfo - Driver Home');
      }
    });
  }
}