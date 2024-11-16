
import 'package:carpool_21_app/src/domain/repository/reserveRepository.dart';

class GetAllReservesUseCase {

  ReserveRepository reserveRepository;

  GetAllReservesUseCase(this.reserveRepository);

  run() => reserveRepository.getMyAllReserves();
}