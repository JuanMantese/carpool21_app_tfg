import 'package:carpool_21_app/src/domain/repository/socketRepository.dart';

class ConnectSocketUseCase {

  SocketRepository socketRepository;

  ConnectSocketUseCase(this.socketRepository);

  run() => socketRepository.connect();

}