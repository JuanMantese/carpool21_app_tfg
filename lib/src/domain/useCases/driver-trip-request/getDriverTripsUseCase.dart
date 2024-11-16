import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';

class GetDriverTripsUseCase {

  DriverTripRequestsRepository driverTripRequestRepository;

  GetDriverTripsUseCase(this.driverTripRequestRepository);

  run() => driverTripRequestRepository.getDriverTrips();
}