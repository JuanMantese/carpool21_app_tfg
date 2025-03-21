import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';

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

// Emitimos la finalizacion del viaje
class TripStartEvent extends PassengerHomeViewEvent {}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends PassengerHomeViewEvent {}

// Socket IO
class ListenUpdateStatusTripSocketIO extends PassengerHomeViewEvent {}

