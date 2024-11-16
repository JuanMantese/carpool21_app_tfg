import 'package:carpool_21_app/src/domain/models/placemarkData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeolocationRepository {

  // Obteniendo posicion del usuario
  Future<Position> findPosition();

  // Agregando marcadores al mapa
  Future<BitmapDescriptor> createMarkerFromAsset(String path);
  
  Marker getMarker( // Marcador
    String markerId,
    double lat, 
    double lng,
    String title,
    String content,
    BitmapDescriptor imageMarker 
  );
  
  // Tomando información del marker (direccion) segun la posición de la camara en el mapa
  Future<PlacemarkData?> getPlacemarkData(CameraPosition cameraPosition);
  
  // Tomando información del marker (direccion) segun su Latitud y Longitud
  Future<PlacemarkData?> getLocationData(LatLng location);

  // Trazando la ruta desde el punto de origen al punto destino
  Future<List<LatLng>> getPolyline(LatLng pickUpLatLng, LatLng destinationLatLng);
  
  // Seguimiento del conductor - Actualiza la posicion del conductor en tiempo real
  Stream<Position> getPositionStream();
}