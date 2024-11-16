import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';

abstract class DriverHomeEvent {}

// Navegando entre las paginas
class ChangeDrawerPage extends DriverHomeEvent {
  final int pageIndex;
  ChangeDrawerPage({ required this.pageIndex });
}

class Logout extends DriverHomeEvent {}

class GetUserInfo extends DriverHomeEvent {
  final UsersService userService;

  GetUserInfo(this.userService);
}