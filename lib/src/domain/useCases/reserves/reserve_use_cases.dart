import 'package:carpool_21_app/src/domain/useCases/reserves/cancel_reserve_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/create_reserve_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/get_all_reserves_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/get_reserve_detail_use_case.dart';

class ReserveUseCases {

  CreateReserveUseCase createReserve;
  GetReserveDetailUseCase getReserveDetailUseCase;
  GetAllReservesUseCase getAllReservesUseCase;
  CancelReserveUseCase cancelReserveUseCase;

  ReserveUseCases({
    required this.createReserve,
    required this.getReserveDetailUseCase,
    required this.getAllReservesUseCase,
    required this.cancelReserveUseCase
  });

}