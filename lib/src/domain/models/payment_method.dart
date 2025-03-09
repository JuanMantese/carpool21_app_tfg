class PaymentMethodModel {
  final String key;
  final String name;
  final String image;
  final String cardNumber;
  final String cardBrand;

  PaymentMethodModel({
    required this.key,
    required this.name,
    required this.image,
    required this.cardNumber,
    required this.cardBrand,
  });

  // Método para crear el modelo desde un Map
  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      key: map['key'],
      name: map['name'],
      image: map['image'],
      cardNumber: map['cardNumber'],
      cardBrand: map['cardBrand'],
    );
  }

  // Método estático para obtener un método de pago por defecto
  static PaymentMethodModel defaultMethod() {
    return PaymentMethodModel(
      key: 'CASH',  // Key por defecto
      name: 'Efectivo',  // Nombre por defecto
      image: 'lib/assets/img/cash-money-icon.png',  // Imagen por defecto
      cardNumber: '',  // Nro por defecto
      cardBrand: 'Efectivo'  // Marca por defecto
    );
  }
}
