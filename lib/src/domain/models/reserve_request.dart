class ReserveRequest {
  int tripRequestId;
  String paymentMethod; // CASH - OtherCard o ID de la tarjeta
  bool? saveNewCard;
  String? cardNumber;
  String? ownerName;
  String? expirationDate;
  int? cvv;

  ReserveRequest({
    required this.tripRequestId,
    required this.paymentMethod,
    this.saveNewCard = false,
    this.cardNumber,
    this.ownerName,
    this.expirationDate,
    this.cvv,
  });

  factory ReserveRequest.fromJson(Map<String, dynamic> json) => ReserveRequest(
    tripRequestId: json["tripRequestId"],
    paymentMethod: json["paymentMethod"],
    saveNewCard: json["saveNewCard"],
    cardNumber: json["cardNumber"],
    ownerName: json["ownerName"],
    expirationDate: json["expirationDate"],
    cvv: json["cvv"],
  );

  Map<String, dynamic> toJson() => {
    'tripRequestId': tripRequestId,
    'paymentMethod': paymentMethod,
    if (saveNewCard != null) 'saveNewCard': saveNewCard,
    if (cardNumber != null) 'cardNumber': cardNumber,
    if (ownerName != null) 'ownerName': ownerName,
    if (expirationDate != null) 'expirationDate': expirationDate,
    if (cvv != null) 'cvv': cvv,
  };
}