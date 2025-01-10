import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';

class CreateCarInfoUseCase {

  CarInfoRepository carInfoRepository;

  CreateCarInfoUseCase(this.carInfoRepository);
  
  run(CarInfo carInfo) => carInfoRepository.create(carInfo);
}