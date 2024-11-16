import 'package:carpool_21_app/src/domain/repository/geolocationRepository.dart';

// Create Marker on Map
class CreateMarkerUseCase {

  GeolocationRepository geolocationRepository;

  CreateMarkerUseCase(this.geolocationRepository);
  
  run(String path) => geolocationRepository.createMarkerFromAsset(path);
}