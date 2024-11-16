
import 'package:carpool_21_app/src/domain/models/tripsAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class TripsState extends Equatable {

  // Resource para traer la información
  final Resource? response;

  final TripsAll? testingTripsAll;

  const TripsState({
    this.response,
    this.testingTripsAll
  });

  TripsState copyWith({
    Resource? response,
    TripsAll? testingTripsAll
  }) {
    return TripsState(
      response: response,
      testingTripsAll: testingTripsAll ?? this.testingTripsAll
    );
  }
  
  @override
  List<Object?> get props => [response, testingTripsAll];

}