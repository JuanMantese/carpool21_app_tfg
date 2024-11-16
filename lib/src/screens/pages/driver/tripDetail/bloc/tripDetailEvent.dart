import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripDetailEvent {}

class GetTripDetail extends TripDetailEvent {
  final int idTrip;

  GetTripDetail({
    required this.idTrip
  });
}

class TripDetailInitMap extends TripDetailEvent {}

class InitializeMap extends TripDetailEvent {}

// Permite cambiar la posicion de la camara del mapa para colocarla sobre la ruta
class ChangeMapCameraPosition extends TripDetailEvent {
  final LatLng pickUpLatLng;
  final LatLng destinationLatLng;

  ChangeMapCameraPosition({
    required this.pickUpLatLng,
    required this.destinationLatLng,
  });
}

// Agregando la ruta al mapa
class AddPolyline extends TripDetailEvent {}