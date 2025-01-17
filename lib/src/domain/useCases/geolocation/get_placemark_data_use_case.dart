import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPlacemarkDataUseCase {

  GeolocationRepository geolocationRepository;

  GetPlacemarkDataUseCase(this.geolocationRepository);

  run(CameraPosition cameraPosition) => geolocationRepository.getPlacemarkData(cameraPosition);
}