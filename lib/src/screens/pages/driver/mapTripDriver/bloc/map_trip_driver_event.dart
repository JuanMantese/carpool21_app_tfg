import 'package:geolocator/geolocator.dart';

abstract class MapTripDriverEvent {}

class GetMapTripDetail extends MapTripDriverEvent {
  final int idTrip;

  GetMapTripDetail({
    required this.idTrip
  });
}

// Inicializando Mapa
class MapTripDriverInitMap extends MapTripDriverEvent {}

// Permite cambiar la posicion de la camara del mapa para colocarla sobre la ruta
class ChangeMapCameraPosition extends MapTripDriverEvent {
  final double lat;
  final double lng;

  ChangeMapCameraPosition({
    required this.lat,
    required this.lng,
  });
}

// Buscamos la posición del Driver
class FindPosition extends MapTripDriverEvent {}

// Actualizamos la Posición del Driver
class UpdatePosition extends MapTripDriverEvent {
  final Position position;

  UpdatePosition({
    required this.position,
  });
}

// Guardamos la Ubicación del Driver (su posición)
// class SaveLocationData extends MapTripDriverEvent {
//   final DriverPosition driverPosition;

//   SaveLocationData({
//     required this.driverPosition,
//   });
// }


// Borramos la Ubicación del Driver (su posición)
// class DeleteLocationData extends MapTripDriverEvent {
//   final int idDriver;

//   DeleteLocationData({
//     required this.idDriver,
//   });
// }

// Detenemos la localización del Driver
class StopLocation extends MapTripDriverEvent {}

class AddMarkerPickup extends MapTripDriverEvent {
  final double lat;
  final double lng;

  AddMarkerPickup({
    required this.lat,
    required this.lng,
  });
}

class AddMarkerDestination extends MapTripDriverEvent {
  final double lat;
  final double lng;

  AddMarkerDestination({
    required this.lat,
    required this.lng,
  });
}
class AddMarkerPositionDriver extends MapTripDriverEvent {
  final double lat;
  final double lng;

  AddMarkerPositionDriver({
    required this.lat,
    required this.lng,
  });
}

// Agregando la ruta al mapa
class AddPolyline extends MapTripDriverEvent {}

// Trayendo los datos: Teimpo estimado del trayecto y Distancia del punto de origen al punto de destino
class GetTimeAndDistanceValues extends MapTripDriverEvent {
  final double driverLat;
  final double driverLng;

  GetTimeAndDistanceValues({
    required this.driverLat,
    required this.driverLng,
  });
}

class ChangeTripStatus extends MapTripDriverEvent {
  final int idTrip;

  ChangeTripStatus({
    required this.idTrip
  });
}

class SetTripFinished extends MapTripDriverEvent {
  final bool tripFinished;
  
  SetTripFinished({
    required this.tripFinished
  });
}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends MapTripDriverEvent {}

// Socket IO
class EmitDriverPositionSocketIO extends MapTripDriverEvent {}
class EmitUpdateStatusTripSocketIO extends MapTripDriverEvent {}
