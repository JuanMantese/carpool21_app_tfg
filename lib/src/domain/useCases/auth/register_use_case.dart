
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/repository/auth_repository.dart';

class RegisterUseCase {

  AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  run(User user) => authRepository.register(user);
}