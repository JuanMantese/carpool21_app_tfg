import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class GetDriverTripsUseCase {

  DriverTripRequestsRepository driverTripRequestRepository;

  GetDriverTripsUseCase(this.driverTripRequestRepository);

  run() => driverTripRequestRepository.getDriverTrips();
}