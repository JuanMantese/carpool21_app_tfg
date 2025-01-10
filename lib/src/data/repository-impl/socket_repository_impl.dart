// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/repository/socket_repository.dart';
import 'package:socket_io_client/src/socket.dart';

class SocketRepositoryImpl implements SocketRepository {

  Socket socket;

  SocketRepositoryImpl(this.socket);

  @override
  Socket connect() {
    return socket.connect();
  }

  @override
  Socket disconnect() {
    // return socket.disconnect();
    if (socket.connected) {
      print('Desconectando socket...');
      socket.disconnect(); // Desconecta el socket
      socket.dispose(); // Libera recursos asociados
    } else {
      print('El socket ya estaba desconectado.');
    }
    return socket;
  }
}