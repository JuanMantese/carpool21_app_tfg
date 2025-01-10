import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class ReservesState extends Equatable {

  final Resource? response; // Resource - Respuesta esperada de la consulta a la API
  final ReservesAll? reservesAll;

  const ReservesState({
    this.response,
    this.reservesAll
  });

  ReservesState copyWith({
    Resource? response,
    ReservesAll? reservesAll
  }) {
    return ReservesState(
      response: response ?? this.response,
      reservesAll: reservesAll ?? this.reservesAll
    );
  }
  
  @override
  List<Object?> get props => [
    response, 
    reservesAll
  ];
}