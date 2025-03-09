import 'dart:async';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailState extends Equatable {

  final Resource? responseGetTripDetail;
  final Resource? responseStartTrip;
  final bool showNewReservesOnTrip;
  
  final Completer<GoogleMapController>? controller;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatLng;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  const TripDetailState({
    this.responseGetTripDetail,
    this.responseStartTrip,
    this.showNewReservesOnTrip = false,
    this.controller,
    this.pickUpLatLng,
    this.destinationLatLng,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
  });

  TripDetailState copyWith({
    Resource? responseGetTripDetail,
    Resource? responseStartTrip,
    bool? showNewReservesOnTrip,

    Completer<GoogleMapController>? controller,
    LatLng? pickUpLatLng,
    LatLng? destinationLatLng,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return TripDetailState(
      responseGetTripDetail: responseGetTripDetail ?? this.responseGetTripDetail,
      responseStartTrip: responseStartTrip ?? this.responseStartTrip,
      showNewReservesOnTrip: showNewReservesOnTrip ?? this.showNewReservesOnTrip,
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
    responseStartTrip,
    showNewReservesOnTrip,
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