import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetLocationDataUseCase {

  GeolocationRepository geolocationRepository;

  GetLocationDataUseCase(this.geolocationRepository);

  run(LatLng location) => geolocationRepository.getLocationData(location);
}