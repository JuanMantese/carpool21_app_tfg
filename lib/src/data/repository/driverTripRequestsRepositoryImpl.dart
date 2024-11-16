
import 'package:carpool_21_app/src/data/dataSource/remote/services/driverTripRequestsService.dart';
import 'package:carpool_21_app/src/domain/models/driverTripRequest.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/models/tripsAll.dart';
import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class DriverTripRequestsRepositoryImpl implements DriverTripRequestsRepository {
  
  DriverTripRequestsService driverTripRequestsService;

  DriverTripRequestsRepositoryImpl(this.driverTripRequestsService);

  @override
  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng
  ) {
    return driverTripRequestsService.getTimeAndDistanceClientRequets(
      originLat, 
      originLng, 
      destinationLat, 
      destinationLng
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