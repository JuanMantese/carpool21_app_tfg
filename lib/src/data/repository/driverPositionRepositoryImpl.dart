
import 'package:carpool_21_app/src/data/dataSource/remote/services/driversPositionService.dart';
import 'package:carpool_21_app/src/domain/models/driverPosition.dart';
import 'package:carpool_21_app/src/domain/repository/driverPositionRepository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class DriversPositionRepositoryImpl implements DriverPositionRepository {

  DriversPositionService driversPositionService;

  DriversPositionRepositoryImpl(this.driversPositionService);

  @override
  Future<Resource<bool>> create(DriverPosition driverPosition) {
    return driversPositionService.create(driverPosition);
  }

  @override
  Future<Resource<bool>> delete(int idDriver) {
    return driversPositionService.delete(idDriver);
  }
  
  @override
  Future<Resource<DriverPosition>> getDriverPosition(int idDriver) {
    return driversPositionService.getDriverPosition(idDriver);
  }

}