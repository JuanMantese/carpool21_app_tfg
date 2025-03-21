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
  final double lat;
  final double lng;

  ChangeMapCameraPosition({
    required this.lat,
    required this.lng,
  });
}

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

// Emitimos la finalizacion del viaje
class TripFinishedEvent extends MapTripPassengerEvent {}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends MapTripPassengerEvent {}

// Socket IO
class ListenDriverPositionSocketIO extends MapTripPassengerEvent {}
class ListenUpdateStatusTripSocketIO extends MapTripPassengerEvent {}