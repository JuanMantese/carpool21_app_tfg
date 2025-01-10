import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';

class GetPositionStreamUseCase {

  GeolocationRepository geolocationRepository;

  GetPositionStreamUseCase(this.geolocationRepository);

  run() => geolocationRepository.getPositionStream();
}