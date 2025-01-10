import 'package:carpool_21_app/src/domain/repository/socket_repository.dart';

class DisconnectSocketUseCase {

  SocketRepository socketRepository;

  DisconnectSocketUseCase(this.socketRepository);

  run() => socketRepository.disconnect();

}