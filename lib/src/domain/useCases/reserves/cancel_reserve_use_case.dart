import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart';

class CancelReserveUseCase {

  ReserveRepository reserveRepository;

  CancelReserveUseCase(this.reserveRepository);

  run(int idReserve) => reserveRepository.cancelReserve(idReserve);
}