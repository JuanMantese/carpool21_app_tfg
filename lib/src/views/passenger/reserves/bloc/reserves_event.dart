abstract class ReservesEvent {}

class GetReservesAll extends ReservesEvent {} 

class CancelReservation extends ReservesEvent {
  final int idReserve;
  CancelReservation({ required this.idReserve });
} 

class ListenReservesAllSocketIO extends ReservesEvent {}