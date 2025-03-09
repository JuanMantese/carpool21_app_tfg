import 'dart:convert';

CarInfo carInfoFromJson(String str) => CarInfo.fromJson(json.decode(str));

String carInfoToJson(CarInfo data) => json.encode(data.toJson());

class CarInfo {
  int? idDriver;
  int? idVehicle;
  String brand;
  String model;
  String patent;
  String color;
  int year;
  String? nroGreenCard;
  String? insuranceCompany;
  String? insuranceType;
  String? insuranceExpiration;
  int? policyNumber;
  int? cuilCuit;

  CarInfo({
    this.idDriver,
    this.idVehicle,
    required this.brand,
    required this.model,
    required this.patent,
    required this.color,
    required this.year,
    this.nroGreenCard,
    this.insuranceCompany,
    this.insuranceType,
    this.insuranceExpiration,
    this.policyNumber,
    this.cuilCuit
  });

  // Recibe una Lista con la informacion de todos los vehiculos del conductor y la convierte en JSON
  static List<CarInfo> fromJsonList(List<dynamic> jsonList) {
    List<CarInfo> toList = [];

    for (var json in jsonList) { 
      CarInfo carList = CarInfo.fromJson(json);
      toList.add(carList);
    }
    return toList;
  }

  factory CarInfo.fromJson(Map<String, dynamic> json) => CarInfo(
    idVehicle: json["idVehicle"],
    brand: json["brand"],
    model: json["model"],
    patent: json["patent"],
    color: json["color"],
    year: json["year"] is String ? int.parse(json["year"]) : json["year"],
    nroGreenCard: json["greenCard"],
    insuranceCompany: json["insuranceCompany"],
    insuranceType: json["insuranceType"],
    insuranceExpiration: _formatDateFromJson(json["insuranceExpiration"]),
    policyNumber: json["policyNumber"] is String ? int.parse(json["policyNumber"]) : json["policyNumber"],
    cuilCuit: json["cuilCuit"] is String ? int.parse(json["cuilCuit"]) : json["cuilCuit"],
  );

  Map<String, dynamic> toJson() => {
    "idVehicle": idVehicle,
    "brand": brand,
    "model": model,
    "patent": patent,
    "color": color,
    "year": year,
    "greenCard": nroGreenCard,
    "insuranceCompany": insuranceCompany,
    "insuranceType": insuranceType,
    "insuranceExpiration": _formatDateToJson(insuranceExpiration),
    "policyNumber": policyNumber,
    "cuil_cuit": cuilCuit,
  };

   // Transforma fecha de YYYY-MM-DD a DD/MM/YYYY (de JSON a objeto)
  static String? _formatDateFromJson(String? date) {
    if (date == null) return null;
    List<String> parts = date.split("-");
    if (parts.length == 3) {
      return "${parts[2]}/${parts[1]}/${parts[0]}"; // Convierte a DD/MM/YYYY
    }
    return date;
  }

  // Transforma fecha de DD/MM/YYYY a YYYY-MM-DD (de objeto a JSON)
  static String? _formatDateToJson(String? date) {
    if (date == null) return null;
    List<String> parts = date.split("/");
    if (parts.length == 3) {
      return "${parts[2]}-${parts[1]}-${parts[0]}"; // Convierte a YYYY-MM-DD
    }
    return date;
  }
}