import 'package:carpool_21_app/src/domain/models/tripDetail.dart';

class ReserveDetail {
  int idReservation;
  bool isPaid;
  TripDetail tripRequest;
  Driver driver; 

  ReserveDetail({
    required this.idReservation,
    required this.isPaid,
    required this.tripRequest,
    required this.driver,
  });

  factory ReserveDetail.fromJson(Map<String, dynamic> json) => ReserveDetail(
    idReservation: json["idReservation"],
    isPaid: json["isPaid"],
    tripRequest: TripDetail.fromJson(json["tripRequest"]),
    driver: Driver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    'idReservation': idReservation,
    'isPaid': isPaid,
    'tripRequest': tripRequest.toJson(),
    'driver': driver.toJson(),
  };
}

class DriverRes {
  int idDriver;
  String name;
  String lastName;
  String phone;
  String? photo;

  DriverRes({
    required this.idDriver,
    required this.name,
    required this.lastName,
    required this.phone,
    this.photo,
  });

  factory DriverRes.fromJson(Map<String, dynamic> json) => DriverRes(
    idDriver: json["idDriver"],
    name: json["name"],
    lastName: json["lastName"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "idDriver": idDriver,
    "name": name,
    "lastName": lastName,
    "phone": phone,
    "photoUser": photo,
  };
}