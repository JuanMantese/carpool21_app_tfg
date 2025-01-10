import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class TripsAvailableState extends Equatable {

  final Resource response; // Resource - Respuesta esperada de la consulta a la API
  final List<TripDetail>? availableTrips;
  final bool showNewTripsAvailable;

  const TripsAvailableState({
    required this.response,
    this.availableTrips,
    this.showNewTripsAvailable = true
  });

  TripsAvailableState copyWith({
    Resource? response,
    List<TripDetail>? availableTrips,
    bool? showNewTripsAvailable,
  }) {
    return TripsAvailableState(
      response: response ?? this.response,
      availableTrips: availableTrips ?? this.availableTrips,
      showNewTripsAvailable: showNewTripsAvailable ?? this.showNewTripsAvailable
    );
  }
  
  @override
  List<Object?> get props => [response, availableTrips, showNewTripsAvailable];
}