
import 'package:carpool_21_app/src/domain/repository/socketRepository.dart';
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
    return socket.disconnect();
  }
}