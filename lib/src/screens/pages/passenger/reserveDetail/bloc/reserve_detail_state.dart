import 'dart:async';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReserveDetailState extends Equatable {

  final Resource? responseGetReserve;
  final ReserveDetail? reserveDetail;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatLng;
  
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  const ReserveDetailState({
    this.responseGetReserve,
    this.reserveDetail, 
    this.pickUpLatLng,
    this.destinationLatLng,
    this.controller,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
  });

  ReserveDetailState copyWith({
    Resource? responseGetReserve,
    ReserveDetail? reserveDetail,
    LatLng? pickUpLatLng,
    LatLng? destinationLatLng,

    Completer<GoogleMapController>? controller,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return ReserveDetailState(
      responseGetReserve: responseGetReserve ?? this.responseGetReserve,
      reserveDetail: reserveDetail ?? this.reserveDetail,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      controller: controller ?? this.controller,
      position: position ?? this.position,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      routeBounds: routeBounds ?? this.routeBounds,
    );
  }

  @override
  List<Object?> get props => [
    responseGetReserve,
    reserveDetail, 
    pickUpLatLng,
    destinationLatLng,
    controller,
    position,
    cameraPosition,
    markers,
    polylines,
    routeBounds
  ];
}