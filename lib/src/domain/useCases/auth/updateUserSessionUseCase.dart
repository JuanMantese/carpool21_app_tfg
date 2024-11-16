
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class UpdateUserSessionUseCase {

  AuthRepository authRepository;

  UpdateUserSessionUseCase(this.authRepository);

  run(User userResponse) => authRepository.updateUserSession(userResponse);
}