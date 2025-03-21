// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_event.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerHomeViewBloc extends Bloc<PassengerHomeViewEvent, PassengerHomeViewState> {

  AuthUseCases authUseCases;
  ReserveUseCases reserveUseCases;
  SocketIOBloc socketIOBloc;

  PassengerHomeViewBloc(
    this.authUseCases, 
    this.reserveUseCases,
    this.socketIOBloc
  ): super(const PassengerHomeViewState()) {
    
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

          add(ListenUpdateStatusTripSocketIO());
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
          emit(
            state.copyWith(
              responseStatus: PassengerHomeViewStatus.error, 
              errorMessage: reservesAllres.message
            )
          );
          return;
        } else {
          print('GetCurrentReserve - ErrorData');
          emit(
            state.copyWith(
              responseStatus: PassengerHomeViewStatus.error, 
              errorMessage: 'No se lograron obtener los datos de la reserva'
            )
          );
        }
      } catch (error) {
        print('Error GetCurrentReserve: $error');
        emit(
          state.copyWith(
            responseStatus: PassengerHomeViewStatus.error, 
            errorMessage: 'Ocurrió un error al obtener la información'
          )
        );
      }
    });

    // Emitimos la finalizacion del viaje
    on<TripStartEvent>((event, emit) {
      emit(
        state.copyWith(
          startTrip: true
        )
      );
    });

    // Reseteo los valores del State al salir de pantalla
    on<ResetState>((event, emit) async {
      print('reseteo');
      
      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Passenger Home View: ${authResponse.user?.idUser}');
        // Desuscribirse del evento del socket
        socketIOBloc.state.socket?.off('trip_status_start/${authResponse.user?.idUser}');
      }

      emit(state.copyWith(startTrip: false));
    });

    // Escuchando el comienzo del viaje reservado
    on<ListenUpdateStatusTripSocketIO>((event, emit) async {
      print('Escuchando el comienzo del viaje reservado >>>>>>>>>>>>>>>>>>>>>');
      await Future.delayed(const Duration(seconds: 5));

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Home: ${authResponse.user?.idUser}');

        if(socketIOBloc.state.socket != null) {
          print('Escuchando ListeUpdateStatusTripSocketIO');
          
          // Elimina listeners previos para evitar duplicados
          socketIOBloc.state.socket?.off('trip_status_start/${authResponse.user?.idUser}');

          socketIOBloc.state.socket?.on('trip_status_start/${authResponse.user?.idUser}', (data) {
              print('Escuchando...');
            
            if (data['state'] == 3) {
              print('Empezo el viaje');
              add(TripStartEvent());
            }
          });
        } else {
          print('No conectado');
        }
      } else {
        print('******************* Passenger Trip Listen Update Trip Socket - AuthResponse es Null *******************');
      }
    });
  }
}