import 'package:carpool_21_app/src/domain/useCases/auth/change_rol_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/get_user_session_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/get_user_token_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/login_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/logout_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/register_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/save_user_session_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/save_user_token_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/update_user_session_use_case.dart';

class AuthUseCases {

  LoginUseCase login;
  LogoutUseCase logout;
  RegisterUseCase register;
  ChangeRolUseCase changeRolUseCase;
  SaveUserSessionUseCase saveUserSession;
  UpdateUserSessionUseCase updateUserSession;
  GetUserSessionUseCase getUserSession;
  SaveUserTokenUseCase saveUserTokenUseCase;
  GetUserTokenUseCase getUserTokenUseCase;

  AuthUseCases({
    required this.login,
    required this.logout,
    required this.register,
    required this.changeRolUseCase,
    required this.saveUserSession,
    required this.updateUserSession,
    required this.getUserSession,
    required this.saveUserTokenUseCase,
    required this.getUserTokenUseCase
  });

}