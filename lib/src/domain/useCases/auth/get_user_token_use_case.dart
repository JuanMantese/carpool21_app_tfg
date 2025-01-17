
import 'package:carpool_21_app/src/domain/repository/auth_repository.dart';

class GetUserTokenUseCase {

  AuthRepository authRepository;

  GetUserTokenUseCase(this.authRepository);

  run() => authRepository.getUserToken();
}