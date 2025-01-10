import 'dart:io';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/repository/users_repository.dart';

class UpdateUserUseCase {

  UsersRepository usersRepository;

  UpdateUserUseCase(this.usersRepository);

  run(
    int id, 
    User user, 
    File? image
  ) => usersRepository.update(
    id,
    user, 
    image
  );
}
