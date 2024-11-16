
import 'package:carpool_21_app/src/domain/models/driverPosition.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class DriverPositionRepository {

  // Creamos la posicion del Driver
  Future<Resource<bool>> create(DriverPosition driverPosition);

  // Eliminamos la posicion del Driver
  Future<Resource<bool>> delete(int idDriver);

  // Traer la posicion del Driver
  Future<Resource<DriverPosition>> getDriverPosition(int idDriver);

}