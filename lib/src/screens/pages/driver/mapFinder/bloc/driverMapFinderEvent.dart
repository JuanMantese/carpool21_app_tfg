
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DriverMapFinderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DriverMapFinderInitEvent extends DriverMapFinderEvent {}

class UpdateDepartureTime extends DriverMapFinderEvent {
  final String time;

  UpdateDepartureTime({required this.time});

  @override
  List<Object?> get props => [time];
}

class FindPosition extends DriverMapFinderEvent {}

// Permite cambiar la posicion de la camara del mapa
class ChangeMapCameraPosition extends DriverMapFinderEvent {
  final double lat; // Latitud
  final double lng; // Longitud

  ChangeMapCameraPosition({
    required this.lat,
    required this.lng,
  });
}

// Obteniendo ubicacion del marker en el mapa al mover la camara
// class OnCameraMove extends DriverMapFinderEvent {
//   CameraPosition cameraPosition;
//   OnCameraMove({required this.cameraPosition});
// }

// class OnCameraIdle extends DriverMapFinderEvent {}

// Seteando el lugar de origen o destino de acuerdo a lo elegido en el modal
class SelectPredefinedLocation extends DriverMapFinderEvent {
  final LatLng location;
  final String neighborhood;
  final String address;
  final String locationType; // 'pickup' or 'destination'

  SelectPredefinedLocation({
    required this.location, 
    required this.neighborhood, 
    required this.address, 
    required this.locationType
  });
}

// El evento se dispara cuando el usuario elije un lugar de Origen
class OnAutoCompletedPickUpSelected extends DriverMapFinderEvent {
  double lat;
  double lng;
  String pickUpText;
  OnAutoCompletedPickUpSelected({required this.lat, required this.lng, required this.pickUpText});
}

// El evento se dispara cuando el usuario elije un lugar de Origen
class OnAutoCompletedDestinationSelected extends DriverMapFinderEvent {
  double lat;
  double lng;
  String destinationText;
  OnAutoCompletedDestinationSelected({required this.lat, required this.lng, required this.destinationText});
}

class DrawPolyline extends DriverMapFinderEvent {}

// Reseteando los valores al salir del Mapa
class ClearPickUpLocation extends DriverMapFinderEvent {}
class ClearDestinationLocation extends DriverMapFinderEvent {}
class DriverMapFinderResetEvent extends DriverMapFinderEvent {}


// Socket IO --------------------------------------------------------
// Conexion y Desconexion al Socket IO
class ConnectSocketIO extends DriverMapFinderEvent {}
class DisconnectSocketIO extends DriverMapFinderEvent {}

// Escuchando los cambios de posicion del Driver - Conectando el Socket y Desconectando el Socket
class ListenDriversPositionSocketIO extends DriverMapFinderEvent {}
class ListenDriversDisconnectedSocketIO extends DriverMapFinderEvent {}

// Permite remover el Marker una vez finalizada la conexion con el Driver
class RemoveDriverPositionMarker extends DriverMapFinderEvent {
  final String idSocket;

  RemoveDriverPositionMarker({ required this.idSocket });
}

// Permite cambiar el Marker en el Mapa, segun como cambie la posicion del usuario Driver
class AddDriverPositionMarker extends DriverMapFinderEvent {
  final String idSocket; // Id del Socket IO de 1 Driver (cada Driver tiene un Id Socket IO distinto)
  final int id;
  final double lat;
  final double lng;

  AddDriverPositionMarker({
    required this.idSocket,
    required this.id,
    required this.lat,
    required this.lng,
  });
}
