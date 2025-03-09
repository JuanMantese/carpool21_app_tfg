
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/payment_method.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripAvailableDetailEvent {}

class TripAvailableDetailInitEvent extends TripAvailableDetailEvent {
  // Cambiando los valores a las variables
  final String pickUpText;
  final LatLng pickUpLatLng;
  final String destinationText;
  final LatLng destinationLatLng;
  final String departureTime;
  final double compensation;
  final Driver driver;
  final CarInfo vehicle;
  
  TripAvailableDetailInitEvent({
    required this.pickUpText,
    required this.pickUpLatLng,
    required this.destinationText,
    required this.destinationLatLng,
    required this.departureTime,
    required this.compensation,
    required this.driver,
    required this.vehicle
  });
}

// Permite cambiar la posicion de la camara del mapa para colocarla sobre la ruta
class ChangeMapCameraPosition extends TripAvailableDetailEvent {
  final LatLng pickUpLatLng;
  final LatLng destinationLatLng;

  ChangeMapCameraPosition({
    required this.pickUpLatLng,
    required this.destinationLatLng,
  });
}

// Agregando la ruta al mapa
class AddPolyline extends TripAvailableDetailEvent {}

// Trayendo los datos: Tiempo estimado del trayecto y Distancia del punto de origen al punto de destino
class GetTimeAndDistanceValues extends TripAvailableDetailEvent {}

class SelectPaymentMethod extends TripAvailableDetailEvent {
  final PaymentMethodModel paymentSelected;
  
  SelectPaymentMethod({
    required this.paymentSelected,
  });
}

class CreateReserve extends TripAvailableDetailEvent {
  final int tripRequestId;
  final PaymentMethodModel paymentMethod;
  final bool? saveNewCard;
  final String? cardNumber;
  final String? cardHolder;
  final String? expiryDate;
  final String? cvv;
  
  CreateReserve({
    required this.tripRequestId,
    required this.paymentMethod,
    this.saveNewCard,
    this.cardNumber,
    this.cardHolder,
    this.expiryDate,
    this.cvv,
  });
}

// Reseteo los valores del State al ejecutar una reserva con Exito
class ResetState extends TripAvailableDetailEvent {}

// Socket IO
class EmitNewReserveRequestSocketIO extends TripAvailableDetailEvent {
  final int idTrip;
  final int idReserve;

  
  EmitNewReserveRequestSocketIO({
    required this.idTrip,
    required this.idReserve,
  });
}