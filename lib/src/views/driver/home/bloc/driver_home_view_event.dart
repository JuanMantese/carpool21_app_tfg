import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';

abstract class DriverHomeViewEvent {}

// Navegando entre las paginas
class ChangeDrawerPage extends DriverHomeViewEvent {
  final int pageIndex;
  ChangeDrawerPage({ required this.pageIndex });
}

class Logout extends DriverHomeViewEvent {}

class GetUserInfo extends DriverHomeViewEvent {
  final UsersService userService;

  GetUserInfo(this.userService);
}