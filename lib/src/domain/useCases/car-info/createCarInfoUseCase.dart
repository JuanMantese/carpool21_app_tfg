
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/repository/carInfoRepository.dart';

class CreateCarInfoUseCase {

  CarInfoRepository carInfoRepository;

  CreateCarInfoUseCase(this.carInfoRepository);
  
  run(CarInfo carInfo) => carInfoRepository.create(carInfo);
}