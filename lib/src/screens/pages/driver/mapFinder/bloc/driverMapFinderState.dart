import 'dart:async';
import 'package:carpool_21_app/src/domain/models/placemarkData.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DriverMapFinderState extends Equatable {

  final Completer<GoogleMapController>? controller;
  final Position? position;
  final Map<MarkerId, Marker> markers; // Manejador de estados de los marcadores
  final Map<PolylineId, Polyline> polylines; // Ruta del origen al destino
  final CameraPosition cameraPosition; // Posicion de la camara en el mapa
  final PlacemarkData? placemarkData; // Marcador en el mapa segun posicion de la camara
  final String pickUpNeighborhood;
  final String pickUpText; // Variable para pasar el texto del input del origen
  final LatLng? pickUpLatLng; // Variable para pasar los datos (Lat y Lng) de origen
  final String destinationNeighborhood; 
  final String destinationText; // Variable para pasar el texto del input del destino
  final LatLng? destinationLatLng; // Variable para pasar los datos (Lat y Lng) de destino
  final String? departureTime; // Horario de Partida
  final bool isLocationSelected; // Variable para saber si el usuario selecciono un lugar desde el Modal
  final Socket? socket; // Actualizacion en tiempo real


  // Constructor 
  DriverMapFinderState({
    this.controller,
    this.position,
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.cameraPosition = const CameraPosition(target: LatLng(-31.322187, -64.2219203), zoom: 15.0),
    this.placemarkData,
    this.pickUpNeighborhood = '',
    this.pickUpText = '',
    this.pickUpLatLng,
    this.destinationNeighborhood = '',
    this.destinationText = '',
    this.destinationLatLng,
    this.departureTime,
    this.isLocationSelected = false,
    this.socket
  });

  // CopuWith - Nos permite cambiamos el estado de las variables
  DriverMapFinderState copyWith({
    Completer<GoogleMapController>? controller,
    Position? position,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    CameraPosition? cameraPosition,
    PlacemarkData? placemarkData,
    String? pickUpNeighborhood,
    String? pickUpText,
    LatLng? pickUpLatLng,
    String? destinationNeighborhood,
    String? destinationText,
    LatLng? destinationLatLng,
    String? departureTime,
    bool? isLocationSelected,
    Socket? socket,
  }) {
    
    return DriverMapFinderState(
      controller: controller ?? this.controller,
      position: position ?? this.position,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      placemarkData: placemarkData ?? this.placemarkData,
      pickUpNeighborhood: pickUpNeighborhood ?? this.pickUpNeighborhood,
      pickUpText: pickUpText ?? this.pickUpText,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationNeighborhood: destinationNeighborhood ?? this.destinationNeighborhood,
      destinationText: destinationText ?? this.destinationText,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      departureTime: departureTime ?? this.departureTime,
      isLocationSelected: isLocationSelected ?? this.isLocationSelected,
      socket: socket ?? this.socket
    );
  }


  @override
  List<Object?> get props => [
    controller, 
    position, 
    markers, 
    polylines, 
    cameraPosition, 
    placemarkData, 
    pickUpNeighborhood,
    pickUpText, 
    pickUpLatLng, 
    destinationNeighborhood,
    destinationText, 
    destinationLatLng, 
    departureTime, 
    isLocationSelected, 
    socket
  ];

}