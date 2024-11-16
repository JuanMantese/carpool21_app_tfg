
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class ReservesState extends Equatable {

  // Resource para traer la información
  final Resource? response;

  final ReservesAll? testingReservesAll;

  const ReservesState({
    this.response,
    this.testingReservesAll
  });

  ReservesState copyWith({
    Resource? response,
    ReservesAll? testingReservesAll
  }) {
    return ReservesState(
      response: response,
      testingReservesAll: testingReservesAll ?? this.testingReservesAll
    );
  }
  
  @override
  List<Object?> get props => [response, testingReservesAll];

}