import 'dart:async';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTripPassengerState extends Equatable {

  final Resource? responseGetReserveDetail;
  final Resource? responseTimeAndDistance;
  final TimeAndDistanceValues? timeAndDistance;
  final bool isRouteDrawed;
  final bool isPaid; // Verificamos si el conductor llego a destino
  
  final Completer<GoogleMapController>? controller;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatLng;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  const MapTripPassengerState({
    this.responseGetReserveDetail,
    this.responseTimeAndDistance,
    this.timeAndDistance,
    this.isPaid = false,
    this.isRouteDrawed = false,
    this.controller,
    this.pickUpLatLng,
    this.destinationLatLng,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
  });

  MapTripPassengerState copyWith({
    Resource? responseGetReserveDetail,
    Resource? responseTimeAndDistance,
    TimeAndDistanceValues? timeAndDistance,
    bool? isRouteDrawed,
    bool? isPaid,

    Completer<GoogleMapController>? controller,
    LatLng? pickUpLatLng,
    LatLng? destinationLatLng,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return MapTripPassengerState(
      responseGetReserveDetail: responseGetReserveDetail ?? this.responseGetReserveDetail,
      responseTimeAndDistance: responseTimeAndDistance ?? this.responseTimeAndDistance,
      timeAndDistance: timeAndDistance ?? this.timeAndDistance,
      isRouteDrawed: isRouteDrawed ?? this.isRouteDrawed,
      isPaid: isPaid ?? this.isPaid,
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
    responseGetReserveDetail,
    responseTimeAndDistance,
    timeAndDistance,
    isRouteDrawed,
    isPaid,
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