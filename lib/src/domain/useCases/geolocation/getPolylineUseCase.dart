import 'package:carpool_21_app/src/domain/repository/geolocationRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPolylineUseCase {

  GeolocationRepository geolocationRepository;

  GetPolylineUseCase(this.geolocationRepository);

  run(LatLng pickUpLatLng, LatLng destinationLatLng) => geolocationRepository.getPolyline(pickUpLatLng, destinationLatLng);
}