import 'package:carpool_21_app/src/domain/useCases/car-info/create_car_info_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/get_car_info_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/get_car_list_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/update_car_info_use_case.dart';

class CarInfoUseCases {

  CreateCarInfoUseCase createCarInfo;
  UpdateCarInfoUseCase updateCarInfo;
  GetCarInfoUseCase getCarInfo;
  GetCarListUseCase getCarList;

  CarInfoUseCases({
    required this.createCarInfo,
    required this.updateCarInfo,
    required this.getCarInfo,
    required this.getCarList,
  });

}