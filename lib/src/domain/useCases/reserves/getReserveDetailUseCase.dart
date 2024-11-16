

import 'package:carpool_21_app/src/domain/repository/reserveRepository.dart';

class GetReserveDetailUseCase {

  ReserveRepository reserveRepository;

  GetReserveDetailUseCase(this.reserveRepository);

  run(int idReserve) => reserveRepository.getReserveDetail(idReserve);
}