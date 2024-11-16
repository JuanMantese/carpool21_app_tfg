class ReserveRequest {
  int tripRequestId;
  bool isPaid;
  // int idTrip;
  // int idPassenger;
  // String name;
  // String lastName;

  ReserveRequest({
    required this.tripRequestId,
    required this.isPaid,
    // required this.idTrip,
    // required this.idPassenger,
    // required this.name,
    // required this.lastName,
  });

  factory ReserveRequest.fromJson(Map<String, dynamic> json) => ReserveRequest(
    tripRequestId: json["tripRequestId"],
    isPaid: json["isPaid"],
    // idTrip: json["idTrip"],
    // idPassenger: json["idPassenger"],
    // name: json["name"],
    // lastName: json["lastName"],
  );

  Map<String, dynamic> toJson() => {
    'tripRequestId': tripRequestId,
    'isPaid': isPaid,
    // 'idTrip': idTrip,
    // 'idPassenger': idPassenger,
    // 'name': name,
    // 'lastName': lastName,
  };
}