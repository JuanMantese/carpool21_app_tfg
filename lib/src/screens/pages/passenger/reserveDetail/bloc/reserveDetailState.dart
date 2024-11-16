import 'dart:async';

import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReserveDetailState extends Equatable {

  final ReserveDetail? reserveDetail;
  final Resource? response;
  
  final Completer<GoogleMapController>? controller;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatLng;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  ReserveDetailState({
    this.reserveDetail, 
    this.response,
    this.controller,
    this.pickUpLatLng,
    this.destinationLatLng,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
  });

  ReserveDetailState copyWith({
    ReserveDetail? reserveDetail,
    Resource? response,

    Completer<GoogleMapController>? controller,
    LatLng? pickUpLatLng,
    LatLng? destinationLatLng,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return ReserveDetailState(
      reserveDetail: reserveDetail ?? this.reserveDetail,
      response: response,
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
    reserveDetail, 
    response,
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