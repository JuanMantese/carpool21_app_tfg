

import 'package:carpool_21_app/src/domain/useCases/users/getUserDetailUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/users/updateUserUseCase.dart';

class UserUseCases {

  UpdateUserUseCase update;
  GetUserDetailUseCase getUserDetailUseCase;

  UserUseCases({
    required this.update,
    required this.getUserDetailUseCase
  });

}
