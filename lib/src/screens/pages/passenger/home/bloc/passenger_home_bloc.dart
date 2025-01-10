// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passenger_home_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passenger_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerHomeBloc extends Bloc<PassengerHomeEvent, PassengerHomeState> {

  AuthUseCases authUseCases;
  ReserveUseCases reserveUseCases;

  PassengerHomeBloc(
    this.authUseCases, 
    this.reserveUseCases
  ): super(const PassengerHomeState()) {
    
    // on<ChangeDrawerPage>((event, emit) {
    //   emit(
    //     state.copyWith(
    //       pageIndex: event.pageIndex, 
    //     )
    //   );
    // });

    // on<Logout>((event, emit) async {
    //   await authUseCases.logout.run();
    // });

    on<GetUserInfo>((event, emit) async {
      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Passenger -------------------');
        print(authResponse.toJson());

        List<Role> roles = authResponse.user!.roles?.map((role) => role).toList() ?? [];
        
        print('Rol: ${roles[0]}');
        
        emit(
          state.copyWith(
            roles: roles,
            currentUser: authResponse.user,
            userService: event.userService, 
          )
        );
      } else {
        print('No se lograron obtener los datos del usuario - GetUserInfo - Passenger Home');
      }
    });

    on<GetCurrentReserve>((event, emit) async {
      print('GetCurrentReserve Home Passenger -------------------');

      // Recuperando las reservas del Pasajero
      Resource reservesAllresponse = await reserveUseCases.getAllReservesUseCase.run();
      print('Response Reserves All: $reservesAllresponse');

      if (reservesAllresponse is Success) {
        ReservesAll reservesAll = reservesAllresponse.data;
        print(reservesAll.toJson());

        emit(
          state.copyWith(
            reservesAll: reservesAll,
          )
        );
      } else {
        print('No se lograron obtener las Reservas');
      }
    });
  }
}