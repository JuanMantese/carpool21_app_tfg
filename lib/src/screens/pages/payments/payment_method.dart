import 'package:carpool_21_app/src/domain/models/card_detail.dart';
import 'package:carpool_21_app/src/domain/models/payment_method.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/payments/bloc/payment_method_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/payments/bloc/payment_method_event.dart';
import 'package:carpool_21_app/src/screens/pages/payments/bloc/payment_method_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethod extends StatefulWidget {
  final PaymentMethodModel selectedMethod;

  const PaymentMethod({
    super.key, 
    required this.selectedMethod
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  
  late PaymentMethodModel _selectedPaymentMethod; // Método de pago predeterminado
  List<Map<String, dynamic>> _paymentMethods = []; // Todos los metodos de pago disponibles
  bool _isUpdated = false; // Controlador de carga del PaymentMethod

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.selectedMethod;
    context.read<PaymentMethodBloc>().add(LoadPaymentMethods()); // Recuperando tarjetas
  }

  // Seteando los Métodos de Pago Disponibles
  void _updatePaymentMethods(List<CardDetail> cards) {

    if (_isUpdated) return;

    final List<Map<String, dynamic>> tempMethods = [
      {"key": "CASH", "name": "Efectivo", "image": 'lib/assets/img/cash-money-icon.png', "cardNumber": "Efectivo", "cardBrand": "Efectivo"},
      {"key": "OtherCard", "name": "Tarjeta Debito/Credito", "image": 'lib/assets/img/debit-credit-card-logo.png', "cardNumber": "Tarjeta Debito/Credito", "cardBrand": "OtherCard"},
      // {"key": "MercadoPago", "name": "Mercado Pago", "image": 'lib/assets/img/card-MercadoPago-logo.png', "cardNumber": ""},
      // {"key": "2", "name": "4000 **** **** 0007", "image": 'lib/assets/img/card-Visa-logo.png', "cardNumber": "4000 **** **** 0007"},
      // {"key": "3", "name": "5100 **** **** 0006", "image": 'lib/assets/img/card-Mastercard-logo.png', "cardNumber": "5100 **** **** 0006"},
      // {"key": "4", "name": "3700 **** **** 0005", "image": 'lib/assets/img/card-Amex-logo.png', "cardNumber": "3700 **** **** 0005", },
    ];

    // Asignando el Logo de cada Método segun el cardBrand
    for (var card in cards) {
      String cardImage = '';
      switch (card.cardBrand.toLowerCase()) {
        case 'visa':
          cardImage = 'lib/assets/img/card-Visa-logo.png';
          break;
        case 'mastercard':
          cardImage = 'lib/assets/img/card-Mastercard-logo.png';
          break;
        case 'amex':
          cardImage = 'lib/assets/img/card-Amex-logo.png';
          break;
        case 'mercadopago':
          cardImage = 'lib/assets/img/card-MercadoPago-logo.png';
          break;
        default:
          cardImage = 'lib/assets/img/debit-credit-card-logo.png'; // Imagen por defecto
          break;
      }
    
      tempMethods.add({
        "key": card.idCard.toString(),
        "image": cardImage,
        "name": '**** **** **** ${card.cardNumber.substring(12)}',
        "cardNumber": card.cardNumber,
        "cardBrand": card.cardBrand,
      });
    }

    setState(() {
      _paymentMethods = tempMethods;
      _isUpdated = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    print('Payments ---');
    print(_paymentMethods);
    print(widget.selectedMethod);

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {  // Se detecta un deslizamiento hacia abajo
          Navigator.pop(context, _selectedPaymentMethod);  // Devuelve el método seleccionado al cerrar
        }
      },
      child: DraggableScrollableSheet(
      initialChildSize: 0.5, // Se abre al 50% de la pantalla
      minChildSize: 0.5, // No se reduce más del 50%
      maxChildSize: 0.8, // No se expande más del 80%
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Opciones de pago",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 28),
                      onPressed: () => Navigator.pop(context, _selectedPaymentMethod), // Devuelve el método seleccionado
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(method["image"], fit: BoxFit.contain),
                      ),
                      title: Text(method["name"]),
                      trailing: _selectedPaymentMethod.key == method["key"]
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = PaymentMethodModel.fromMap(method);
                        });
                      },
                    );
                  },
                ),
              ),

              BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                builder: (context, state) {
                  final cardsRes = state.paymentsRes;
                  if (cardsRes is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (cardsRes is Success) {
                    final cards = cardsRes.data ?? [];

                    // Usar addPostFrameCallback para evitar la llamada directa a setState
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _updatePaymentMethods(cards);
                    });
                    return Container(); // Retorna vacío mientras se actualizan las tarjetas
                  } else if (state.paymentsRes is Error) {
                    return const Center(child: Text("Hubo un error al cargar las tarjetas."));
                  }
                  return Container();
                },
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "Agregar método de pago +",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
      ),
    );
  }
}