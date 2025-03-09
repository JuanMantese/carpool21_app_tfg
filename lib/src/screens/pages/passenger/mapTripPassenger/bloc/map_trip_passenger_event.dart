import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapTripPassengerEvent {}

class GetMapReserveDetail extends MapTripPassengerEvent {
  final int idReserve;

  GetMapReserveDetail({
    required this.idReserve
  });
}

// Inicializando Mapa
class MapTripPassangerInitMap extends MapTripPassengerEvent {}

// Permite cambiar la posicion de la camara del mapa para colocarla sobre la ruta
class ChangeMapCameraPosition extends MapTripPassengerEvent {
  final LatLng pickUpLatLng;
  final LatLng destinationLatLng;

  ChangeMapCameraPosition({
    required this.pickUpLatLng,
    required this.destinationLatLng,
  });
}

// TESTEANDO ESTA FORMA DE COLOCAR LOS MARKERS
class AddMarkerPickup extends MapTripPassengerEvent {
  final double lat;
  final double lng;

  AddMarkerPickup({
    required this.lat,
    required this.lng,
  });
}

class AddMarkerDestination extends MapTripPassengerEvent {
  final double lat;
  final double lng;

  AddMarkerDestination({
    required this.lat,
    required this.lng,
  });
}
class AddMarkerDriver extends MapTripPassengerEvent {
  final double lat;
  final double lng;

  AddMarkerDriver({
    required this.lat,
    required this.lng,
  });
}
// FINALIZA EL TESTONG ------------------



// Agregando la ruta al mapa
class AddPolyline extends MapTripPassengerEvent {
  final double driverLat;
  final double driverLng;

  AddPolyline({
    required this.driverLat,
    required this.driverLng,
  });
}

// Trayendo los datos: Teimpo estimado del trayecto y Distancia desede la ubicación del conductor al punto de destino
class GetTimeAndDistanceValues extends MapTripPassengerEvent {
  final double driverLat;
  final double driverLng;

  GetTimeAndDistanceValues({
    required this.driverLat,
    required this.driverLng,
  });
}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends MapTripPassengerEvent {}

// Socket IO
class ListenDriverPositionSocketIO extends MapTripPassengerEvent {}
