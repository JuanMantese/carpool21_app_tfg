
import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';

class GetTimeAndDistanceUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  GetTimeAndDistanceUseCase(this.driverTripRequestsRepository);

  run(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng
  ) => driverTripRequestsRepository.getTimeAndDistanceClientRequets(
    originLat, 
    originLng, 
    destinationLat, 
    destinationLng
  );
}