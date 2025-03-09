// Detalle de un pago
class PaymentDetail {
  int idPayment;
  String paymentMethod;
  String paymentAmount;
  String paymentDate;

  PaymentDetail({
    required this.idPayment,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.paymentDate,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    idPayment: json["idPayment"],
    paymentMethod: json["paymentMethod"],
    paymentAmount: json["paymentAmount"],
    paymentDate: json["paymentDate"],
  );

  Map<String, dynamic> toJson() => {
    "idPayment": idPayment,
    "paymentMethod": paymentMethod,
    "paymentAmount": paymentAmount,
    "paymentDate": paymentDate,
  };
}
