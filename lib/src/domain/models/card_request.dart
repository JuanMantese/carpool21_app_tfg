// Datos para el registro de una Tarjeta
class CardRequest {
  String cardNumber;
  String ownerName;
  String expirationDate;
  int cvv;

  CardRequest({
    required this.cardNumber,
    required this.ownerName,
    required this.expirationDate,
    required this.cvv,
  });

  factory CardRequest.fromJson(Map<String, dynamic> json) => CardRequest(
    cardNumber: json["cardNumber"],
    ownerName: json["ownerName"],
    expirationDate: json["expirationDate"],
    cvv: json["cvv"],
  );

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "ownerName": ownerName,
    "expirationDate": expirationDate,
    "cvv": cvv,
  };

   // Método para rotar la fecha
  static String rotateExpirationDate(String expirationDate) {
    // Suponemos que expirationDate está en formato MM/YYYY
    List<String> parts = expirationDate.split('/');
    if (parts.length == 2) {
      return '${parts[1]}/${parts[0]}';  // Cambiar a YYYY/MM
    } else {
      throw const FormatException('Fecha de expiración no tiene el formato MM/YYYY');
    }
  }
}
