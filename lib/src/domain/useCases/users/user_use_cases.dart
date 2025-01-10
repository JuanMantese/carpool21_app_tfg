import 'package:carpool_21_app/src/domain/useCases/users/get_user_detail_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/users/update_user_use_case.dart';

class UserUseCases {

  UpdateUserUseCase update;
  GetUserDetailUseCase getUserDetailUseCase;

  UserUseCases({
    required this.update,
    required this.getUserDetailUseCase
  });

}
