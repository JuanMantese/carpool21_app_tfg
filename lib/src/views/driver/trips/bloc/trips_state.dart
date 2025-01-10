import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class TripsState extends Equatable {

  final Resource? response; // Resource - Respuesta esperada de la consulta a la API
  final TripsAll? tripsAll;

  const TripsState({
    this.response,
    this.tripsAll
  });

  TripsState copyWith({
    Resource? response,
    TripsAll? tripsAll
  }) {
    return TripsState(
      response: response ?? this.response,
      tripsAll: tripsAll ?? this.tripsAll
    );
  }
  
  @override
  List<Object?> get props => [
    response, 
    tripsAll
  ];
}