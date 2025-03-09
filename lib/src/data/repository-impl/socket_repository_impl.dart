// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/repository/socket_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/src/socket.dart';

class SocketRepositoryImpl implements SocketRepository {

  Socket socket;

  SocketRepositoryImpl(this.socket);

  @override
  Socket connect(String userId) {
    // return socket.connect();

    socket.connect();

    // Una vez conectado, unirse al grupo personalizado
    socket.onConnect((_) {
      print('Socket conectado con éxito');
      socket.emit('join_user', {'userId': userId}); // Enviar el ID del usuario
      print('Unido a la sala personalizada: user_$userId');
    });

    return socket;
  }

  @override
  Socket disconnect() {
    // return socket.disconnect();
    if (socket.connected) {
      print('Desconectando socket...');
      socket.emit('leave_user', {}); // Notificar al servidor que se está desconectando
      socket.disconnect(); // Desconecta el socket
      socket.dispose(); // Libera recursos asociados
    } else {
      print('El socket ya estaba desconectado.');
    }
    return socket;
  }
}