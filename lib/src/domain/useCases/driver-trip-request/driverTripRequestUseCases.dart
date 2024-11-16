
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/createTripRequestUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getAllTripsUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getDriverTripsUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getTimeAndDistanceUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getTripDetailUseCase.dart';

class DriverTripRequestsUseCases {

  CreateTripRequestUseCase createTripRequestUseCase;
  GetTimeAndDistanceUseCase getTimeAndDistance;
  GetTripDetailUseCase getTripDetailUseCase;
  GetDriverTripsUseCase getDriverTripsUseCase;

  // Get Current Trip
  // Get Historical Trips
  // Get Next Trips
  GetAllTripsUseCase getAllTripsUseCase;

  DriverTripRequestsUseCases({
    required this.createTripRequestUseCase,
    required this.getTimeAndDistance,
    required this.getTripDetailUseCase,
    required this.getDriverTripsUseCase,
    required this.getAllTripsUseCase
  });

}