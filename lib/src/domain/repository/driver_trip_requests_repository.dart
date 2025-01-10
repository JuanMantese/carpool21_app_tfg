
import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class DriverTripRequestsRepository {

  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat,
    double originLng,
    double destinationLat,
    double destinationLng,
    String departureTime
  );

  Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest);

  Future<Resource<TripDetail>> getTripDetail(int idTrip);

  // Obtenemos todos los viajes registrados de un conductor
  Future<Resource<TripsAll>> getDriverTrips();

  // Obtenemos todos los viajes disponibles
  Future<Resource<List<TripDetail>>> getAvailableTrips();

}