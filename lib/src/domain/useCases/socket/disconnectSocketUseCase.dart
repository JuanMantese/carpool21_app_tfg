import 'package:carpool_21_app/src/domain/repository/socketRepository.dart';

class DisconnectSocketUseCase {

  SocketRepository socketRepository;

  DisconnectSocketUseCase(this.socketRepository);

  run() => socketRepository.disconnect();

}