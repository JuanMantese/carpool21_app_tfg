import 'package:carpool_21_app/src/domain/models/reserve_request.dart';
import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart';

class CreateReserveUseCase {

  ReserveRepository reserveRepository;

  CreateReserveUseCase(this.reserveRepository);

  run(ReserveRequest reserveRequest) => reserveRepository.create(reserveRequest);
}