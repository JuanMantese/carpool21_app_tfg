import 'package:carpool_21_app/src/domain/repository/users_repository.dart';

class ChangeRolUseCase {

  UsersRepository usersRepository;

  ChangeRolUseCase(this.usersRepository);

  run(String idRole) => usersRepository.changeRol(idRole);  
}