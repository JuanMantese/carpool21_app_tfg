// ignore_for_file: avoid_print
import 'dart:async';

import 'package:carpool_21_app/blocSocketIO/socket_io_event.dart';
import 'package:carpool_21_app/blocSocketIO/socket_io_state.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOBloc extends Bloc<SocketIOEvent, SocketIOState> {

  SocketUseCases socketUseCases;

  SocketIOBloc(this.socketUseCases): super(const SocketIOState()) {

    // El Socket se conecta cuando el usuario inicia sesion en la App
    on<ConnectSocketIO>((event, emit) async {
      print('Intentando conectar el SOCKET... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print('User ${event.idUser}');

      try {
        final Socket socket = await socketUseCases.connect.run(event.idUser);

        // Configurar un Completer para manejar la conexión inicial y las posibles reconecciones
        final completer = Completer<void>();

        void onConnect(_) async {
          print('Socket conectado exitosamente');
          print('Socket ID: ${socket.id}');
          print('Socket URL: ${socket.io.uri}');

          if (!completer.isCompleted) {
            completer.complete();
          }

          // Emitir el estado actualizado dentro del flujo del evento
          if (!emit.isDone) {
            emit(state.copyWith(socket: socket));
          }
        }

        void onError(dynamic error) async {
          print('Error al conectar el socket: $error');
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        }

        // Eliminar listeners previos y configurar nuevos
        socket.off('connect');
        socket.off('connect_error');
        socket.on('connect', onConnect);
        socket.on('connect_error', onError);

        // Esperar conexión inicial
        await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            if (!completer.isCompleted) {
              completer.completeError('Timeout: no se pudo conectar al socket.');
            }
          },
        );
      } catch (e) {
        print('Error al intentar conectar el socket: $e');
      }
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