import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart';

class GetAllReservesUseCase {

  ReserveRepository reserveRepository;

  GetAllReservesUseCase(this.reserveRepository);

  run() => reserveRepository.getMyAllReserves();
}