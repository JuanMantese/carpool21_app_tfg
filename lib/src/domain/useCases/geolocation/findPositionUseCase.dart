import 'package:carpool_21_app/src/domain/repository/geolocationRepository.dart';

class FindPositionUseCase {

  GeolocationRepository geolocationRepository;

  FindPositionUseCase(this.geolocationRepository);

  run() => geolocationRepository.findPosition();
}