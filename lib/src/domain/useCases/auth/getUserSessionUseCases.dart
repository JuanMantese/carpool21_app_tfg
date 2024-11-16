
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class GetUserSessionUseCase {

  AuthRepository authRepository;

  GetUserSessionUseCase(this.authRepository);

  run() => authRepository.getUserSession();
}