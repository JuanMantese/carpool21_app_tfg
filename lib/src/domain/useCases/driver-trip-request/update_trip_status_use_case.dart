import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class UpdateTripStatusUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  UpdateTripStatusUseCase(this.driverTripRequestsRepository);

  run(int idTrip, int newStatus) => driverTripRequestsRepository.updateTripStatus(idTrip, newStatus);
}