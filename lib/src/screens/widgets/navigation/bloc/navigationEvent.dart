// navigation_event.dart
import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';

abstract class NavigationEvent {}

class ShowInicio extends NavigationEvent {}

class ShowReservas extends NavigationEvent {}

class ShowViaje extends NavigationEvent {}

class ShowPerfil extends NavigationEvent {}

class Logout extends NavigationEvent {}

class GetUserInfo extends NavigationEvent {
  final UsersService userService;
  GetUserInfo(this.userService);
}

class ChangeUserRol extends NavigationEvent {
  final String idRole;
  ChangeUserRol(this.idRole);
}