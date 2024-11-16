
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class TripsAvailableState extends Equatable {

  // Resource para traer la información
  final Resource? response;

  final List<TripDetail>? availableTrips;

  TripsAvailableState({
    this.response,
    this.availableTrips
  });

  TripsAvailableState copyWith({
    Resource? response,
    List<TripDetail>? availableTrips
  }) {
    return TripsAvailableState(
      response: response,
      availableTrips: availableTrips
    );
  }
  
  @override
  List<Object?> get props => [response, availableTrips];

}