import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class LogoutUseCase {

  AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  run() => authRepository.logout();
}