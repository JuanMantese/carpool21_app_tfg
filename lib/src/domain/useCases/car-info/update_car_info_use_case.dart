import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';

class UpdateCarInfoUseCase {

  CarInfoRepository carInfoRepository;

  UpdateCarInfoUseCase(this.carInfoRepository);
  
  run(int idDriver, CarInfo carInfo) => carInfoRepository.create(carInfo);
}
