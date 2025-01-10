import 'package:carpool_21_app/src/domain/models/driver_position.dart';
import 'package:carpool_21_app/src/domain/repository/driver_position_repository.dart';

class CreateDriverPositionUseCase {

  DriverPositionRepository driverPositionRepository;

  CreateDriverPositionUseCase(this.driverPositionRepository);

  run(DriverPosition driverPosition) => driverPositionRepository.create(driverPosition);
}