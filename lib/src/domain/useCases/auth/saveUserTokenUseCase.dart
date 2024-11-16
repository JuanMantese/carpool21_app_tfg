
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class SaveUserTokenUseCase {

  AuthRepository authRepository;

  SaveUserTokenUseCase(this.authRepository);

  run(AuthResponse authResponse) => authRepository.saveUserToken(authResponse);
}