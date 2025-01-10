import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';

class FindPositionUseCase {

  GeolocationRepository geolocationRepository;

  FindPositionUseCase(this.geolocationRepository);

  run() => geolocationRepository.findPosition();
}