
import 'package:carpool_21_app/src/domain/models/driverTripRequest.dart';
import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';

class CreateTripRequestUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  CreateTripRequestUseCase(this.driverTripRequestsRepository);

  run(DriverTripRequest driverTripRequest) => driverTripRequestsRepository.create(driverTripRequest);
}