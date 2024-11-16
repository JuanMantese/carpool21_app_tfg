import 'dart:convert';

DriverTripRequest driverTripRequestFromJson(String str) => DriverTripRequest.fromJson(json.decode(str));

String driverTripRequestToJson(DriverTripRequest data) => json.encode(data.toJson());


class DriverTripRequest {
  int vehicleId;
  String pickupNeighborhood;
  String pickupText;
  double pickupLat;
  double pickupLng;
  String destinationNeighborhood;
  String destinationText;
  double destinationLat;
  double destinationLng;
  // int compensation;
  int availableSeats; // Plazas disponibles
  String departureTime; // Horario de salida
  String? observations;

  DriverTripRequest({
    required this.vehicleId,
    // required this.compensation,
    required this.pickupNeighborhood,
    required this.pickupText,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationNeighborhood,
    required this.destinationText,
    required this.destinationLat,
    required this.destinationLng,
    required this.availableSeats,
    required this.departureTime,
    this.observations,
  });

  factory DriverTripRequest.fromJson(Map<String, dynamic> json) => DriverTripRequest(
    vehicleId: json["vehicleId"],
    // compensation: json["compensation"],
    pickupNeighborhood: json["pickupNeighborhood"],
    pickupText: json["pickupText"],
    pickupLat: (json['pickupLat'] as num).toDouble(),
    pickupLng: (json['pickupLng'] as num).toDouble(),
    destinationNeighborhood: json["destinationNeighborhood"],
    destinationText: json["destinationText"],
    destinationLat: (json['destinationLat'] as num).toDouble(),
    destinationLng: (json['destinationLng'] as num).toDouble(),
    availableSeats: json["availableSeats"],
    departureTime: json["departureTime"],
    observations: json["observations"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    // "compensation": compensation,
    "pickupNeighborhood": pickupNeighborhood,
    "pickupText": pickupText,
    "pickupLat": pickupLat,
    "pickupLng": pickupLng,
    "destinationNeighborhood": destinationNeighborhood,
    "destinationText": destinationText,
    "destinationLat": destinationLat,
    "destinationLng": destinationLng,
    "availableSeats": availableSeats,
    "departureTime": departureTime,
    "observations": observations,
  };
}