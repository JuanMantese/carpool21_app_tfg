abstract class TripsAvailableEvent {}

class GetNearbyTripRequest extends TripsAvailableEvent {
  final double driverLat;
  final double driverLng;

  GetNearbyTripRequest({
    required this.driverLat,
    required this.driverLng
  });
}

class GetTripsAvailable extends TripsAvailableEvent {}
