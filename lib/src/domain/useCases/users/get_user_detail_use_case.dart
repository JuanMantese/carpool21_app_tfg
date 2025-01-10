import 'package:carpool_21_app/src/domain/repository/users_repository.dart';

class GetUserDetailUseCase {

  UsersRepository usersRepository;

  GetUserDetailUseCase(this.usersRepository);

  run() => usersRepository.getUserDetail();
}
