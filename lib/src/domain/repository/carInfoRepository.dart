import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class CarInfoRepository {

  // Registro de nuevo vehiculo
  Future<Resource<CarInfo>> create(CarInfo carInfo);

  // Actualizando datos de un Vehiculo
  Future<Resource<CarInfo>> update(int idDriver, CarInfo car);

  // Trayendo los datos de un vehiculo
  Future<Resource<CarInfo>> getCarInfo(int idDriver);

  // Trayendo los datos de todos los vehiculos de un conductor
  Future<Resource<List<CarInfo>>> getCarList();

}