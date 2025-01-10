
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CreateTripEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeTrip extends CreateTripEvent {
  final String pickUpNeighborhood;
  final String pickUpText;
  late LatLng pickUpLatLng;
  final String destinationNeighborhood;
  final String destinationText;
  late LatLng destinationLatLng;
  final String departureTime;
  final TimeAndDistanceValues timeAndDistanceValues;

  InitializeTrip({
    required this.pickUpNeighborhood,
    required this.pickUpText,
    required this.pickUpLatLng,
    required this.destinationNeighborhood,
    required this.destinationText,
    required this.destinationLatLng,
    required this.departureTime,
    required this.timeAndDistanceValues,
  });

  @override
  List<Object?> get props => [
    pickUpText, 
    pickUpLatLng, 
    destinationText, 
    destinationLatLng,
    departureTime, 
    timeAndDistanceValues,
  ];
}

class UpdateNeighborhood extends CreateTripEvent {
  final String neighborhood;

  UpdateNeighborhood({required this.neighborhood});

  @override
  List<Object?> get props => [neighborhood];
}

class UpdateVehicle extends CreateTripEvent {
  final int vehicle;

  UpdateVehicle({required this.vehicle});

  @override
  List<Object?> get props => [vehicle];
}

class UpdateAvailableSeats extends CreateTripEvent {
  final int seats;

  UpdateAvailableSeats({required this.seats});

  @override
  List<Object?> get props => [seats];
}

class UpdateTripObservations extends CreateTripEvent {
  final String tripObservationsInput;

  UpdateTripObservations({required this.tripObservationsInput});

  @override
  List<Object?> get props => [tripObservationsInput];
}

class CreateTripRequest extends CreateTripEvent {}

// Reseteo los valores del State al ejecutar una reserva con Exito
class ResetState extends CreateTripEvent {}

// Socket IO
class EmitNewTripRequestSocketIO extends CreateTripEvent {}
