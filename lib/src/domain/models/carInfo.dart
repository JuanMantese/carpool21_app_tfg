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

    CarInfo({
      this.idDriver,
      this.idVehicle,
      required this.brand,
      required this.model,
      required this.patent,
      required this.color,
      required this.year,
      this.nroGreenCard,
    });

  // Recibe una Lista con la informacion de todos los vehiculos del conductor y la convierte en JSON
  static List<CarInfo> fromJsonList(List<dynamic> jsonList) {
    List<CarInfo> toList = [];

    jsonList.forEach((json) { 
      CarInfo carList = CarInfo.fromJson(json);
      toList.add(carList);
    });
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
    );

    Map<String, dynamic> toJson() => {
      "idVehicle": idVehicle,
      "brand": brand,
      "model": model,
      "patent": patent,
      "color": color,
      "year": year,
      "greenCard": nroGreenCard,
    };
}