import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ReserveDetailEvent {}

class GetReserveDetail extends ReserveDetailEvent {
  final int idReserve;

  GetReserveDetail({
    required this.idReserve
  });
}

// Inicializando Mapa
class InitializeMap extends ReserveDetailEvent {}

// Permite cambiar la posicion de la camara del mapa para colocarla sobre la ruta
class ChangeMapCameraPosition extends ReserveDetailEvent {
  final LatLng pickUpLatLng;
  final LatLng destinationLatLng;

  ChangeMapCameraPosition({
    required this.pickUpLatLng,
    required this.destinationLatLng,
  });
}

// Agregando la ruta al mapa
class AddPolyline extends ReserveDetailEvent {}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends ReserveDetailEvent {}