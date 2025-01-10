
import 'package:carpool_21_app/src/data/dataSource/remote/services/car_info_service.dart';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class CarInfoRepositoryImpl implements CarInfoRepository{

  CarInfoService carInfoService;

  CarInfoRepositoryImpl(this.carInfoService);

  @override
  Future<Resource<CarInfo>> create(CarInfo carInfo) {
    return carInfoService.create(carInfo);
  }

  @override
  Future<Resource<CarInfo>> update(int idDriver, CarInfo car) {
    return carInfoService.update(idDriver, car);
  }

  @override
  Future<Resource<CarInfo>> getCarInfo(int idDriver) {
    return carInfoService.getCarInfo(idDriver);
  }

  @override
  Future<Resource<List<CarInfo>>> getCarList() {
    return carInfoService.getCarList();
  }

}