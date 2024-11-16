import 'package:carpool_21_app/src/domain/repository/geolocationRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Get Map Marker 
class GetMarkerUseCase {
  
  GeolocationRepository geolocationRepository;

  GetMarkerUseCase(this.geolocationRepository);
  
  run(String markerId, double lat, double lng, String title, String content, BitmapDescriptor imageMarker) => geolocationRepository.getMarker(markerId, lat, lng, title, content, imageMarker);
}