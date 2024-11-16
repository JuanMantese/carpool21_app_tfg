
import 'package:carpool_21_app/src/domain/models/driverTripRequest.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/models/tripsAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class DriverTripRequestsRepository {

  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat,
    double originLng,
    double destinationLat,
    double destinationLng,
  );

  Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest);

  Future<Resource<TripDetail>> getTripDetail(int idTrip);

  // Obtenemos todos los viajes registrados de un conductor
  Future<Resource<TripsAll>> getDriverTrips();

  // Obtenemos todos los viajes disponibles
  Future<Resource<List<TripDetail>>> getAvailableTrips();

}