// Detalle de una Tarjeta
class CardDetail {
  int idCard;
  String cardNumber;
  String ownerName;
  String expirationDate;
  int cvv;
  String cardBrand;
  bool active;

  CardDetail({
    required this.idCard,
    required this.cardNumber,
    required this.ownerName,
    required this.expirationDate,
    required this.cvv,
    required this.cardBrand,
    required this.active,
  });

  factory CardDetail.fromJson(Map<String, dynamic> json) => CardDetail(
    idCard: json["idCard"],
    cardNumber: json["cardNumber"],
    ownerName: json["ownerName"],
    expirationDate: json["expirationDate"],
    cvv: json["cvv"],
    cardBrand: json["cardBrand"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "idCard": idCard,
    "cardNumber": cardNumber,
    "ownerName": ownerName,
    "expirationDate": expirationDate,
    "cvv": cvv,
    "cardBrand": cardBrand,
    "active": active,
  };
}
