abstract class CarInfoEvent {}

class GetCarInfo extends CarInfoEvent {
  final int idVehicle;

  GetCarInfo({ required this.idVehicle });
}
