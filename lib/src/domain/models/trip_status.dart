
class TripStatus {
  int idTrip;
  int status;
  String message;

  TripStatus({
    required this.idTrip,
    required this.status,
    required this.message,
  });

  factory TripStatus.fromJson(Map<String, dynamic> json) => TripStatus(
    idTrip: json["idTrip"],
    status: json["newStatus"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "idUser": idTrip,
    "newStatus": status,
    "lastName": message,
  };
}
