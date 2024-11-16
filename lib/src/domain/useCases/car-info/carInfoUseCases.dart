
import 'package:carpool_21_app/src/domain/useCases/car-info/createCarInfoUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/getCarInfoUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/getCarListUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/updateCarInfoUseCase.dart';

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