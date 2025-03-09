
import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/trip_status.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class DriverTripRequestsRepository {

  Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest);

  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat,
    double originLng,
    double destinationLat,
    double destinationLng,
    String departureTime
  );

  Future<Resource<TripDetail>> getTripDetail(int idTrip);

  // Obtenemos todos los viajes registrados de un conductor
  Future<Resource<TripsAll>> getDriverTrips();

  // Obtenemos todos los viajes disponibles
  Future<Resource<List<TripDetail>>> getAvailableTrips();

  // Actualizamos el estado de un vaje
  Future<Resource<TripStatus>> updateTripStatus(int idTrip, int newStatus);
}