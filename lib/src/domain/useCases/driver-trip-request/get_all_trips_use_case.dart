import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class GetAllTripsUseCase {

  DriverTripRequestsRepository driverTripRequestRepository;

  GetAllTripsUseCase(this.driverTripRequestRepository);

  run() => driverTripRequestRepository.getAvailableTrips();
}