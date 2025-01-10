import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';

class GetCarInfoUseCase {

  CarInfoRepository carInfoRepository;
  
  GetCarInfoUseCase(this.carInfoRepository);
  
  run(int idDriver) => carInfoRepository.getCarInfo(idDriver);
}