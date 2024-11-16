
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/repository/reserveRepository.dart';

class CreateReserveUseCase {

  ReserveRepository reserveRepository;

  CreateReserveUseCase(this.reserveRepository);

  run(ReserveRequest reserveRequest) => reserveRepository.create(reserveRequest);
}