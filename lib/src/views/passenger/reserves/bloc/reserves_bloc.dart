// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_event.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservesBloc extends Bloc<ReservesEvent, ReservesState> {

  AuthUseCases authUseCases;
  ReserveUseCases reserveUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;

  ReservesBloc(
    this.authUseCases,
    this.reserveUseCases,
    this.socketUseCases, 
    this.socketIOBloc
  ): super(const ReservesState()) {

    on<GetReservesAll>((event, emit) async {
      print('GetReservesAll ---------------------');
      print('Estado actual antes de actualizar: ${state.reservesAll}');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );

      // Recuperando las reservas del Pasajero
      Resource<ReservesAll> reservesAllRes = await reserveUseCases.getAllReservesUseCase.run();
      print('Response - $reservesAllRes');
      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          response: reservesAllRes,
        )
      );

      if (reservesAllRes is Success<ReservesAll>) {
        print('Estado actualizado con viajes disponibles: ${reservesAllRes.data}');

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        add(ListenReservesAllSocketIO());

        emit(
          state.copyWith(
            reservesAll: reservesAllRes.data,
          )
        );
      }
    }); 


    // Escuchamos las nuevas ofertas de Viajes disponibles
    on<ListenReservesAllSocketIO>((event, emit) async {
      print('Escuchando nuevas ofertas de viajes disponibles >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(socketIOBloc.state.socket);
      print(socketIOBloc.state.socket?.connected);

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Passenger Reserves: ${authResponse.user?.idUser}');

        if (socketIOBloc.state.socket != null && socketIOBloc.state.socket!.connected) {
          print('Entramos a la escucha');
          
          socketIOBloc.state.socket?.on('reserves_all_changed_notification/${authResponse.user?.idUser}', (data) async {
            print('Cambios detectados en las Reservas - Socket IO');
            print(data);

            // Actualizando la pantalla con los viajes disponibles 
            add(GetReservesAll());
          });
        }
      } else {
        print('******************* Passenger Reserves - AuthResponse es Null *******************');
      }
    });

  }
}
