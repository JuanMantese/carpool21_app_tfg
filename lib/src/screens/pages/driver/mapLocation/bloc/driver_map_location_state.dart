import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationState extends Equatable {

  final Completer<GoogleMapController>? controller;
  final Position? position;
  final Map<MarkerId, Marker> markers; // Manejador de estados de los marcadores
  final CameraPosition cameraPosition; // Posicion de la camara en el mapa
  final int? idDriver;

  // Constructor 
  DriverMapLocationState({
    this.controller,
    this.position,
    this.markers = const <MarkerId, Marker>{},
    this.cameraPosition = const CameraPosition(target: LatLng(-31.322187, -64.2219203), zoom: 15.0),
    this.idDriver
  });

  // CopuWith - Nos permite cambiar el estado de las variables
  DriverMapLocationState copyWith({
    Completer<GoogleMapController>? controller,
    Position? position,
    Map<MarkerId, Marker>? markers,
    CameraPosition? cameraPosition,
    int? idDriver,
  }) {
    
    return DriverMapLocationState(
      controller: controller ?? this.controller,
      position: position ?? this.position,
      markers: markers ?? this.markers,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      idDriver: idDriver ?? this.idDriver
    );
  }

  @override
  List<Object?> get props => [controller, position, markers, cameraPosition, idDriver];
}