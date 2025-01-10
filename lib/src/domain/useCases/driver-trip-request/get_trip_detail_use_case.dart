import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';

class GetTripDetailUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  GetTripDetailUseCase(this.driverTripRequestsRepository);

  run(int idTrip) => driverTripRequestsRepository.getTripDetail(idTrip);
}