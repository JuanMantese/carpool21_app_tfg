import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class GetTimeAndDistanceUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  GetTimeAndDistanceUseCase(this.driverTripRequestsRepository);

  run(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng,
    String departureTime
  ) => driverTripRequestsRepository.getTimeAndDistanceClientRequets(
    originLat, 
    originLng, 
    destinationLat,
    destinationLng,
    departureTime
  );
}