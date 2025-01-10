import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class CreateTripRequestUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  CreateTripRequestUseCase(this.driverTripRequestsRepository);

  run(DriverTripRequest driverTripRequest) => driverTripRequestsRepository.create(driverTripRequest);
}