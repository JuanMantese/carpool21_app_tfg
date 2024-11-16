
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/repository/carInfoRepository.dart';

class UpdateCarInfoUseCase {

  CarInfoRepository carInfoRepository;

  UpdateCarInfoUseCase(this.carInfoRepository);
  
  run(int idDriver, CarInfo carInfo) => carInfoRepository.create(carInfo);
}
