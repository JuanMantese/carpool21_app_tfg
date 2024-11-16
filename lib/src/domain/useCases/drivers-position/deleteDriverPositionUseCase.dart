
import 'package:carpool_21_app/src/domain/repository/driverPositionRepository.dart';

class DeleteDriverPositionUseCase {

  DriverPositionRepository driverPositionRepository;

  DeleteDriverPositionUseCase(this.driverPositionRepository);

  run(int idDriver) => driverPositionRepository.delete(idDriver);
}