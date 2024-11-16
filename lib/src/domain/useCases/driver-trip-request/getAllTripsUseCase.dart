import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';

class GetAllTripsUseCase {

  DriverTripRequestsRepository driverTripRequestRepository;

  GetAllTripsUseCase(this.driverTripRequestRepository);

  run() => driverTripRequestRepository.getAvailableTrips();
}