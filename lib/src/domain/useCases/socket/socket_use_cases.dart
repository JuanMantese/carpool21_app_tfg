
import 'package:carpool_21_app/src/domain/useCases/socket/connect_socket_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/disconnect_socket_use_case.dart';

class SocketUseCases {

  ConnectSocketUseCase connect;
  DisconnectSocketUseCase disconnect;

  SocketUseCases({
    required this.connect,
    required this.disconnect
  });
}