
import 'package:carpool_21_app/src/domain/repository/passengerRequestRepository.dart';

class GetNearbyTripRequestUseCase {

  PassengerRequestRepository passengerRequestsRepository;
  
  GetNearbyTripRequestUseCase(this.passengerRequestsRepository);

  run(double driverLat, double driverLng) => passengerRequestsRepository.getNearbyTripRequest(driverLat, driverLng);

}