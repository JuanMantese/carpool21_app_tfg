import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/create_trip_request_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_all_trips_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_driver_trips_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_time_and_distance_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_trip_detail_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/update_trip_status_use_case.dart';

class DriverTripRequestsUseCases {

  CreateTripRequestUseCase createTripRequestUseCase;
  GetTimeAndDistanceUseCase getTimeAndDistance;
  GetTripDetailUseCase getTripDetailUseCase;
  GetDriverTripsUseCase getDriverTripsUseCase;

  // Get Current Trip
  // Get Historical Trips
  // Get Next Trips
  GetAllTripsUseCase getAllTripsUseCase;
  UpdateTripStatusUseCase updateTripStatusUseCase;

  DriverTripRequestsUseCases({
    required this.createTripRequestUseCase,
    required this.getTimeAndDistance,
    required this.getTripDetailUseCase,
    required this.getDriverTripsUseCase,
    required this.getAllTripsUseCase,
    required this.updateTripStatusUseCase
  });

}