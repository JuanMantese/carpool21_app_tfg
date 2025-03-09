import 'dart:async';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/payment_method.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripAvailableDetailState extends Equatable {

  final Completer<GoogleMapController>? controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines; // Permite trazar la ruta origen/destino
  final LatLngBounds? routeBounds; // Recuadro que se crea para envolver los limites de la ruta (Polyline)

  final String pickUpText;
  final LatLng? pickUpLatLng;
  final String destinationText;
  final LatLng? destinationLatLng;
  final String? departureTime;
  final double? compensation;
  final Driver? driver;
  final CarInfo? vehicle;

  final PaymentMethodModel paymentMethodSelected;
  final Resource? responseReserve;
  final Resource? responseTimeAndDistance;
  

  TripAvailableDetailState({
    this.controller,
    this.position,
    this.cameraPosition = const CameraPosition(target: LatLng(-31.3992803, -64.2766129), zoom: 13.0),
    this.markers = const <MarkerId, Marker>{},
    this.polylines = const <PolylineId, Polyline>{},
    this.routeBounds,
    this.pickUpText = '',
    this.pickUpLatLng,
    this.destinationText = '',
    this.destinationLatLng,
    this.departureTime,
    this.compensation,
    this.driver,
    this.vehicle,
    PaymentMethodModel? paymentMethodSelected,
    this.responseReserve,
    this.responseTimeAndDistance,
  }) : paymentMethodSelected = paymentMethodSelected ?? PaymentMethodModel.defaultMethod();

  TripAvailableDetailState copyWith({
    Completer<GoogleMapController>? controller,
    Position? position,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
    LatLngBounds? routeBounds,
    String? pickUpText,
    LatLng? pickUpLatLng,
    String? destinationText,
    LatLng? destinationLatLng,
    String? departureTime,
    double? compensation,
    Driver? driver,
    CarInfo? vehicle,
    PaymentMethodModel? paymentMethodSelected,
    Resource? responseReserve,
    Resource? responseTimeAndDistance,
  }) {
    return TripAvailableDetailState(
      controller: controller ?? this.controller,
      position: position ?? this.position,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      routeBounds: routeBounds ?? this.routeBounds,
      pickUpText: pickUpText ?? this.pickUpText,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationText: destinationText ?? this.destinationText,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      departureTime: departureTime ?? this.departureTime,
      compensation: compensation ?? this.compensation,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      paymentMethodSelected: paymentMethodSelected ?? this.paymentMethodSelected,
      responseReserve: responseReserve ?? this.responseReserve,
      responseTimeAndDistance: responseTimeAndDistance ?? this.responseTimeAndDistance,
    );
  }


  @override
  List<Object?> get props => [
    controller, 
    position, 
    cameraPosition, 
    markers, 
    polylines, 
    routeBounds,
    pickUpText, 
    pickUpLatLng, 
    destinationText, 
    destinationLatLng, 
    departureTime, 
    compensation,
    driver,
    vehicle,
    paymentMethodSelected,
    responseReserve,
    responseTimeAndDistance, 
  ];
}