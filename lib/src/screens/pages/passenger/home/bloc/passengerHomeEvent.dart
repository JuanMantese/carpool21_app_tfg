import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';

abstract class PassengerHomeEvent {}

// Navegando entre las paginas
class ChangeDrawerPage extends PassengerHomeEvent {
  final int pageIndex;
  ChangeDrawerPage({ required this.pageIndex });
}

class Logout extends PassengerHomeEvent {}

class GetUserInfo extends PassengerHomeEvent {
  final UsersService userService;

  GetUserInfo(this.userService);
}

class GetCurrentReserve extends PassengerHomeEvent {} 

