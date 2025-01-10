// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_event.dart';
import 'package:carpool_21_app/blocSocketIO/socket_io_state.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOBloc extends Bloc<SocketIOEvent, SocketIOState> {

  SocketUseCases socketUseCases;

  SocketIOBloc(this.socketUseCases): super(const SocketIOState()) {

    // El Socket se conecta cuando el usuario inicia sesion en la App
    on<ConnectSocketIO>((event, emit) {
      print('AQUI SI ENTRA AL SOCKET >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      
      Socket socket = socketUseCases.connect.run();
  
      print('Socket conectado: ${socket.connected}');
      print('Socket ID: ${socket.id}');
      print('Socket URL: ${socket.io.uri}');
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');

      emit(
        state.copyWith(socket: socket)
      );
    });

    // El Socket se desconecta cuando el usuario cierra sesion en la App
    on<DisconnectSocketIO>((event, emit) {
      print('AQUI SE DESCONECTA EL SOCKET <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
      
      // Eliminar todos los listeners del socket antes de desconectarlo
      if (state.socket != null) {
        state.socket!.offAny();
      }

      socketUseCases.disconnect.run();
      
      emit(
        state.copyWith(socket: null)
      );
    });
  }

}