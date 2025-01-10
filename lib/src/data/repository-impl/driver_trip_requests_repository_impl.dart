
import 'package:carpool_21_app/src/data/dataSource/remote/services/driver_trip_requests_service.dart';
import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class DriverTripRequestsRepositoryImpl implements DriverTripRequestsRepository {
  
  DriverTripRequestsService driverTripRequestsService;

  DriverTripRequestsRepositoryImpl(this.driverTripRequestsService);

  @override
  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng,
    String departureTime
  ) {
    return driverTripRequestsService.getTimeAndDistanceClientRequets(
      originLat, 
      originLng, 
      destinationLat, 
      destinationLng,
      departureTime
    );
  }

  @override
  Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest) {
    return driverTripRequestsService.create(driverTripRequest);
  }

  @override
  Future<Resource<TripDetail>> getTripDetail(int idTrip) {
    return driverTripRequestsService.getTripDetail(idTrip);
  }

  @override
  Future<Resource<TripsAll>> getDriverTrips() {
    return driverTripRequestsService.getDriverTrips();
  }

  @override
  Future<Resource<List<TripDetail>>> getAvailableTrips() {
    return driverTripRequestsService.getAvailableTrips();
  }
}