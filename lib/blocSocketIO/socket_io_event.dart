abstract class SocketIOEvent {}

class ConnectSocketIO extends SocketIOEvent {
  final String idUser;

  ConnectSocketIO({
    required this.idUser
  });
} 

class DisconnectSocketIO extends SocketIOEvent {} 