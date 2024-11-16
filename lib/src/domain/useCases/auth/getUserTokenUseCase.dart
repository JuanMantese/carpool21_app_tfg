
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';

class GetUserTokenUseCase {

  AuthRepository authRepository;

  GetUserTokenUseCase(this.authRepository);

  run() => authRepository.getUserToken();
}