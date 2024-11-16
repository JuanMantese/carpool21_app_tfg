import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';

abstract class PassengerHomeViewEvent {}

// Navegando entre las paginas
class ChangeDrawerPage extends PassengerHomeViewEvent {
  final int pageIndex;
  ChangeDrawerPage({ required this.pageIndex });
}

class Logout extends PassengerHomeViewEvent {}

class GetUserInfo extends PassengerHomeViewEvent {
  final UsersService userService;

  GetUserInfo(this.userService);
}

class GetCurrentReserve extends PassengerHomeViewEvent {} 

