import 'dart:convert';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';

TripDetail passengerRequestFromJson(String str) => TripDetail.fromJson(json.decode(str));

String passengerRequestToJson(TripDetail data) => json.encode(data.toJson());

class TripDetail {
  int idTrip;
  int idDriver;
  Driver? driver;
  String pickupNeighborhood;
  String pickupText;
  double pickupLat;
  double pickupLng;
  String destinationNeighborhood;
  String destinationText;
  double destinationLat;
  double destinationLng;
  int? availableSeats;
  String departureTime; // Date Format
  double? distance; // En kilometros
  int? timeDifference; // En minutos
  double? compensation;
  CarInfo? vehicle;
  String? observations;
  List<Reservations>? reservations;

  // GoogleDistanceMatrix? googleDistanceMatrix;
  // Position pickupPosition;
  // Position destinationPosition;

  TripDetail({
    required this.idTrip,
    required this.idDriver,
    this.driver,
    required this.pickupNeighborhood,
    required this.pickupText,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationNeighborhood,
    required this.destinationText,
    required this.destinationLat,
    required this.destinationLng,
    this.availableSeats,
    required this.departureTime,
    this.distance,
    this.timeDifference,
    this.compensation,
    this.vehicle,
    this.observations,
    this.reservations,
    // this.googleDistanceMatrix,
    // required this.pickupPosition,
    // required this.destinationPosition,
  });

  // Recibe una Lista con la informacion de todos los viajes disponibles y la convierte en JSON
  static List<TripDetail> fromJsonList(List<dynamic> jsonList) {
    List<TripDetail> toList = [];

    jsonList.forEach((json) { 
      TripDetail clientRequestResponse = TripDetail.fromJson(json);
      toList.add(clientRequestResponse);
    });
    return toList;
  }

  factory TripDetail.fromJson(Map<String, dynamic> json) => TripDetail(
    idTrip: json["idTrip"],
    idDriver: json["idDriver"],
    driver: json["driver"] != null ? Driver.fromJson(json["driver"]) : null,
    pickupNeighborhood: json["pickupNeighborhood"],
    pickupText: json["pickupText"],
    pickupLat: json["pickupLat"]?.toDouble(),
    pickupLng: json["pickupLng"]?.toDouble(),
    destinationNeighborhood: json["destinationNeighborhood"],
    destinationText: json["destinationText"],
    destinationLat: json["destinationLat"]?.toDouble(),
    destinationLng: json["destinationLng"]?.toDouble(),
    availableSeats: json["availableSeats"],
    departureTime: json["departureTime"],
    distance: json["distance"]?.toDouble(),
    timeDifference: json["timeDifference"],
    compensation: json["compensation"]?.toDouble(),
    vehicle: json["vehicle"] != null ? CarInfo.fromJson(json["vehicle"]) : null,
    observations: json["observations"],
    reservations: json["reservations"] != null ? List<Reservations>.from(json["reservations"].map((x) => Reservations.fromJson(x))) : null,
    // googleDistanceMatrix: json["google_distance_matrix"] != null ? GoogleDistanceMatrix.fromJson(json["google_distance_matrix"]) : null, 
    // pickupPosition: Position.fromJson(json["pickup_position"]),
    // destinationPosition: Position.fromJson(json["destination_position"]),
  );

  Map<String, dynamic> toJson() => {
    "idTrip": idTrip,
    "idDriver": idDriver,
    "driver": driver?.toJson(),
    "pickupNeighborhood": pickupNeighborhood,
    "pickupText": pickupText,
    "pickuplat": pickupLat,
    "pickupLng": pickupLng,
    "destinationNeighborhood": destinationNeighborhood,
    "destinationText": destinationText,
    "destinationLat": destinationLat,
    "destinationLng": destinationLng,
    "availableSeats": availableSeats,
    "departureTime": departureTime,
    "distance": distance,
    "timeDifference": timeDifference,
    "compensation": compensation,
    "vehicle": vehicle?.toJson(),
    "observations": observations,
    "reservations": reservations != null ? List<dynamic>.from(reservations!.map((x) => x.toJson())) : null,
    // "google_distance_matrix": googleDistanceMatrix?.toJson(),
    // "pickup_position": pickupPosition.toJson(),
    // "destination_position": destinationPosition.toJson(),
  };
}

class Driver {
  String name;
  String lastName;
  String phone;
  String? photo;

  Driver({
    required this.name,
    required this.lastName,
    required this.phone,
    this.photo,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    name: json["name"],
    lastName: json["lastName"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lastName": lastName,
    "phone": phone,
    "photoUser": photo,
  };
}

class Passenger {
  int idUser;
  String name;
  String lastName;
  String phone;
  String? photo;

  Passenger({
    required this.idUser,
    required this.name,
    required this.lastName,
    required this.phone,
    this.photo,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    idUser: json["idUser"],
    name: json["name"],
    lastName: json["lastName"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "name": name,
    "lastName": lastName,
    "phone": phone,
    "photoUser": photo,
  };
}

class Reservations {
  int idReservation;
  bool isPaid;
  Passenger? passenger;

  Reservations({
    required this.idReservation,
    required this.isPaid,
    required this.passenger,
  });

  factory Reservations.fromJson(Map<String, dynamic> json) => Reservations(
    idReservation: json["idReservation"], 
    isPaid: json["isPaid"], 
    passenger: json["passenger"] != null ? Passenger.fromJson(json["passenger"]) : null,

  );

  Map<String, dynamic> toJson() => {
    "idReservation": idReservation,
    "isPaid": isPaid,
    "passenger": passenger?.toJson(),
  };
}

class PositionTrip {
  double x;
  double y;

  PositionTrip({
    required this.x,
    required this.y,
  });

  factory PositionTrip.fromJson(Map<String, dynamic> json) => PositionTrip(
    x: json["x"]?.toDouble(),
    y: json["y"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };
}

class GoogleDistanceMatrix {
  DistanceMatrix distance;
  DistanceMatrix duration;
  String status;

  GoogleDistanceMatrix({
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory GoogleDistanceMatrix.fromJson(Map<String, dynamic> json) => GoogleDistanceMatrix(
    distance: DistanceMatrix.fromJson(json["distance"]),
    duration: DistanceMatrix.fromJson(json["duration"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "status": status,
  };
}

class DistanceMatrix {
  String text;
  int value;

  DistanceMatrix({
    required this.text,
    required this.value,
  });

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) => DistanceMatrix(
    text: json["text"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}