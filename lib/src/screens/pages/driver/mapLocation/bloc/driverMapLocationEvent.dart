
import 'package:carpool_21_app/src/domain/models/driverPosition.dart';
import 'package:geolocator/geolocator.dart';

abstract class DriverMapLocationEvent {}

class DriverMapLocationInitEvent extends DriverMapLocationEvent {}

class FindPosition extends DriverMapLocationEvent {}

// Permite cambiar la posicion de la camara del mapa
class ChangeMapCameraPosition extends DriverMapLocationEvent {
  final double lat; // Latitud
  final double lng; // Longitud

  ChangeMapCameraPosition({
    required this.lat,
    required this.lng,
  });
}

// Permite actualizar la posicion del usuario en el mapa
class UpdateLocation extends DriverMapLocationEvent {
  final Position position;
  UpdateLocation({required this.position});
}

// Permite detener el seguimiento de la posicion del usuario
class StopLocation extends DriverMapLocationEvent {}

// Guardando la posicion del Driver
class SaveLocationData extends DriverMapLocationEvent {
  final DriverPosition driverPosition;
  SaveLocationData({required this.driverPosition});
}

// Eliminando la informacion de la posicion del Driver
class DeleteLocationData extends DriverMapLocationEvent {
  final int idDriver;
  DeleteLocationData({required this.idDriver});
}

// Marker de la posicion del usuario
class AddMyPositionMarker extends DriverMapLocationEvent {
  final double lat;
  final double lng;
  AddMyPositionMarker({ required this.lat, required this.lng });
}

// Conexion y Desconexion al Socket IO
class ConnectSocketIO extends DriverMapLocationEvent {}
class DisconnectSocketIO extends DriverMapLocationEvent {}

// Emitiendo señal del usuario Driver
class EmitDriverPositionSocketIO extends DriverMapLocationEvent {}


// class ListenDriversPositionSocketIO extends DriverMapLocationEvent {}
// class ListenDriversDisconnectedSocketIO extends DriverMapLocationEvent {}
// class RemoveDriverPositionMarker extends DriverMapLocationEvent {
//   final String idSocket;

//   RemoveDriverPositionMarker({ required this.idSocket });
// }
// class AddDriverPositionMarker extends DriverMapLocationEvent {

//   final String idSocket;
//   final int id;
//   final double lat;
//   final double lng;

//   AddDriverPositionMarker({
//     required this.idSocket,
//     required this.id,
//     required this.lat,
//     required this.lng,
//   });

// }
