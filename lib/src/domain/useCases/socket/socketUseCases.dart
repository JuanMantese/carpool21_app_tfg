
import 'package:carpool_21_app/src/domain/useCases/socket/connectSocketUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/disconnectSocketUseCase.dart';

class SocketUseCases {

  ConnectSocketUseCase connect;
  DisconnectSocketUseCase disconnect;

  SocketUseCases({
    required this.connect,
    required this.disconnect
  });
}