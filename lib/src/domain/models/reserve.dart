class ReserveRequest {
  int tripRequestId;
  bool isPaid;

  ReserveRequest({
    required this.tripRequestId,
    required this.isPaid,
  });

  factory ReserveRequest.fromJson(Map<String, dynamic> json) => ReserveRequest(
    tripRequestId: json["tripRequestId"],
    isPaid: json["isPaid"],
  );

  Map<String, dynamic> toJson() => {
    'tripRequestId': tripRequestId,
    'isPaid': isPaid,
  };
}