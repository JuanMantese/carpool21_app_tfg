import 'package:carpool_21_app/src/domain/repository/driver_position_repository.dart';

class GetDriverPositionUseCase {

  DriverPositionRepository driverPositionRepository;

  GetDriverPositionUseCase(this.driverPositionRepository);

  run(int idDriver) => driverPositionRepository.getDriverPosition(idDriver);
}