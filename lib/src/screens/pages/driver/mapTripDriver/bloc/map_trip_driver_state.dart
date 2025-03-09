import 'dart:async';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTripDriverState extends Equatable {

  final Resource? responseGetTripDetail;
  final Resource? responseTimeAndDistance;
  final Resource? responseEndTrip;
  final TimeAndDistanceValues? timeAndDistance;
  final int? idPassenger;
  final bool isArrived; // Verificamos si el conductor llego a destino

  
  final Completer<GoogleMapController>? controller;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatLng;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  const MapTripDriverState({
    this.responseGetTripDetail,
    this.responseTimeAndDistance,
    this.responseEndTrip,
    this.timeAndDistance,
    this.idPassenger,
    this.isArrived = false,
    this.controller,
    this.pickUpLatLng,
    this.destinationLatLng,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
  });

  MapTripDriverState copyWith({
    Resource? responseGetTripDetail,
    Resource? responseTimeAndDistance,
    Resource? responseEndTrip,
    TimeAndDistanceValues? timeAndDistance,
    int? idPassenger,
    bool? isArrived,

    Completer<GoogleMapController>? controller,
    LatLng? pickUpLatLng,
    LatLng? destinationLatLng,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return MapTripDriverState(
      responseGetTripDetail: responseGetTripDetail ?? this.responseGetTripDetail,
      responseTimeAndDistance: responseTimeAndDistance ?? this.responseTimeAndDistance,
      responseEndTrip: responseEndTrip ?? this.responseEndTrip,
      timeAndDistance: timeAndDistance ?? this.timeAndDistance,
      idPassenger: idPassenger ?? this.idPassenger,
      isArrived: isArrived ?? this.isArrived,
      controller: controller ?? this.controller,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      position: position ?? this.position,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      routeBounds: routeBounds ?? this.routeBounds,
    );
  }

  @override
  List<Object?> get props => [
    responseGetTripDetail,
    responseTimeAndDistance,
    responseEndTrip,
    timeAndDistance,
    idPassenger,
    isArrived,
    controller,
    pickUpLatLng,
    destinationLatLng,
    position,
    cameraPosition,
    markers,
    polylines,
    routeBounds
  ];
}