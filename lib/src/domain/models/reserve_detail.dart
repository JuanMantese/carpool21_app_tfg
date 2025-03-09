import 'package:carpool_21_app/src/domain/models/payment_detail.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';

class ReserveDetail {
  int idReservation;
  bool isPaid;
  TripDetail tripRequest;
  Driver driver;
  PaymentDetail? payment;

  ReserveDetail({
    required this.idReservation,
    required this.isPaid,
    required this.tripRequest,
    required this.driver,
    this.payment,
  });

  factory ReserveDetail.fromJson(Map<String, dynamic> json) => ReserveDetail(
    idReservation: json["idReservation"],
    isPaid: json["isPaid"],
    tripRequest: TripDetail.fromJson(json["tripRequest"]),
    driver: Driver.fromJson(json["driver"]),
    payment: json["payment"] != null ? PaymentDetail.fromJson(json["payment"]) : null,
  );

  Map<String, dynamic> toJson() => {
    'idReservation': idReservation,
    'isPaid': isPaid,
    'tripRequest': tripRequest.toJson(),
    'driver': driver.toJson(),
    if (payment != null) 'payment': payment!.toJson(),
  };
}
