
import 'package:carpool_21_app/src/data/dataSource/remote/services/passenger_request_service.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/repository/passenger_request_repository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class PassengerRequestRepositoryImpl implements PassengerRequestRepository {
  
  PassengerRequestsService passengerRequestsService;

  PassengerRequestRepositoryImpl(this.passengerRequestsService);

  @override
  Future<Resource<List<TripDetail>>> getNearbyTripRequest(double driverLat, double driverLng) {
    return passengerRequestsService.getNearbyTripRequest(driverLat, driverLng);
  }
  
}