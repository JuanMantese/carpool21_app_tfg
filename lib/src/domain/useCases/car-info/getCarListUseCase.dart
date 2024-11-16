
import 'package:carpool_21_app/src/domain/repository/carInfoRepository.dart';

class GetCarListUseCase {

  CarInfoRepository carInfoRepository;
  
  GetCarListUseCase(this.carInfoRepository);

  run() => carInfoRepository.getCarList();
}