
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class LoginUseCase {

  AuthRepository repository;

  LoginUseCase(this.repository);

  run(String email, String password) => repository.login(email, password);  
}