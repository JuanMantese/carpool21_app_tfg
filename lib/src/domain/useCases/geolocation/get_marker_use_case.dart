import 'dart:ui';

import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Get Map Marker 
class GetMarkerUseCase {
  
  GeolocationRepository geolocationRepository;

  GetMarkerUseCase(this.geolocationRepository);
  
  run(
    String markerId, 
    double lat, 
    double lng, 
    String title, 
    String content, 
    BitmapDescriptor imageMarker,
    { 
      Offset anchor = const Offset(0.5, 1), // Parámetro opcional con valor por defecto
    }
  ) => geolocationRepository.getMarker(markerId, lat, lng, title, content, imageMarker, anchor: anchor);
}