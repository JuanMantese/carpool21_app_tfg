
import 'package:carpool_21_app/src/domain/repository/auth_repository.dart';

class ChangeRolUseCase {

  AuthRepository repository;

  ChangeRolUseCase(this.repository);

  run(String idRole) => repository.changeRol(idRole);  
}