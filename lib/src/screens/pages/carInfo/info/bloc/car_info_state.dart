import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class CarInfoState extends Equatable {

  final Resource response;

  const CarInfoState({
    required this.response
  });

  CarInfoState copyWith({
    Resource? response
  }) {
    return CarInfoState(
      response: response ?? this.response
    );
  }

  @override
  List<Object?> get props => [response];
}