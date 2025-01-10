import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';

class GetCarListUseCase {

  CarInfoRepository carInfoRepository;
  
  GetCarListUseCase(this.carInfoRepository);

  run() => carInfoRepository.getCarList();
}