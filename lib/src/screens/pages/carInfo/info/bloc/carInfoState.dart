import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:equatable/equatable.dart';

class CarInfoState extends Equatable {

  final CarInfo? car;

  CarInfoState({this.car});

  CarInfoState copyWith({
    CarInfo? car
  }) {
    return CarInfoState(car: car);
  }

  @override
  List<Object?> get props => [car];
}