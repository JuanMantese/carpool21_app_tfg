
import 'package:carpool_21_app/src/domain/repository/usersRepository.dart';

class GetUserDetailUseCase {

  UsersRepository usersRepository;

  GetUserDetailUseCase(this.usersRepository);

  run() => usersRepository.getUserDetail();
}
