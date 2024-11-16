
import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';

class GetTripDetailUseCase {

  DriverTripRequestsRepository driverTripRequestsRepository;

  GetTripDetailUseCase(this.driverTripRequestsRepository);

  run(int idTrip) => driverTripRequestsRepository.getTripDetail(idTrip);
}