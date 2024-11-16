import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class CarListState extends Equatable {

  // Resource para traer la información de todos los vehiculos
  final Resource? response;

  final List<CarInfo>? testingArrayCars;

  CarListState({
    this.response,
    this.testingArrayCars
  });

  CarListState copyWith({
    Resource? response,
    List<CarInfo>? testingArrayCars
  }) {
    return CarListState(
      response: response,
      testingArrayCars: testingArrayCars
    );
  }

  @override
  List<Object?> get props => [response, testingArrayCars];
}