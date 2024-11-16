
import 'package:carpool_21_app/src/domain/models/driverPosition.dart';
import 'package:carpool_21_app/src/domain/repository/driverPositionRepository.dart';

class CreateDriverPositionUseCase {

  DriverPositionRepository driverPositionRepository;

  CreateDriverPositionUseCase(this.driverPositionRepository);

  run(DriverPosition driverPosition) => driverPositionRepository.create(driverPosition);
}