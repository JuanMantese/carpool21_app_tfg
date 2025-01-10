import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class CarListState extends Equatable {

  // Resource para traer la información de todos los vehiculos
  final Resource response;

  const CarListState({
    required this.response,
  });

  CarListState copyWith({
    Resource? response,
    List<CarInfo>? testingArrayCars
  }) {
    return CarListState(
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [response];
}