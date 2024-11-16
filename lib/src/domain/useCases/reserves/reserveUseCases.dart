
import 'package:carpool_21_app/src/domain/useCases/reserves/createReserveUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/getAllReservesUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/getReserveDetailUseCase.dart';

class ReserveUseCases {

  CreateReserveUseCase createReserve;
  GetReserveDetailUseCase getReserveDetailUseCase;
  GetAllReservesUseCase getAllReservesUseCase;

  ReserveUseCases({
    required this.createReserve,
    required this.getReserveDetailUseCase,
    required this.getAllReservesUseCase
  });
}