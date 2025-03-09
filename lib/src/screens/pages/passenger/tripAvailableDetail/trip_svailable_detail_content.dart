// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/payment_method.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/card_register.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_state.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_button.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_dialog.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:carpool_21_app/src/screens/pages/payments/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripAvailableDetailContent extends StatefulWidget {
  
  final TripAvailableDetailState state;
  final void Function(
    String? cardNumber, 
    String? cardHolder, 
    String? expiryDate, 
    String? cvv
  )? onReserve;
  final VoidCallback onMapInitialized;
  
  const TripAvailableDetailContent(
    this.state, 
    {
      super.key,
      required this.onReserve,
      required this.onMapInitialized,
    }
  );

  @override
  State<TripAvailableDetailContent> createState() => _TripAvailableDetailContentState();
}

class _TripAvailableDetailContentState extends State<TripAvailableDetailContent> {

  // Info Trip Card
  bool _showTripInfo = false;
  final double _tripButtonPosition = 80; // Posición inicial (se actualiza dinámicamente)
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double draggableHeight = constraints.maxHeight * 0.06; // Altura cuando el draggable está contraído

        return Stack(
          children: [
            // Background Map
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: draggableHeight,
              child: _googleMaps(context),
            ),
            
            // Animación de la Card
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              top: _showTripInfo ? _tripButtonPosition + 50 : _tripButtonPosition, // Se desplaza desde el botón
              left: 10,
              right: 10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showTripInfo ? 1.0 : 0.0,
                child: _buildTripInfoCard(context),
              ),
            ),

            // Back Button
            CustomIconBack(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
              color: Colors.black,
              onPressed: () {
                context.pop();
              },
            ),

            // Info Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 15,
              right: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTripInfo = !_showTripInfo;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF00A98F)),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(
                      color: Color(0xFF00A98F),
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.info_rounded, 
                      color: Colors.white
                    ),
                  ],
                ),
              ),
            ),

            _draggableCardBookingInfo(context, constraints),
          ],
        );
      }
    );
  }

  // Mostrando la ruta dell viaje
  Widget _googleMaps(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: GoogleMap(  // Mapa de Google
        onMapCreated: (GoogleMapController controller) {
          // controller.setMapStyle('JSON');
          
          print('Mapa creado, controlador: $controller');
          context.read<TripAvailableDetailBloc>().setMapController(controller);

          // Avisamos que el mapa se inicializo y completo su construcción
          widget.onMapInitialized();
        },
        mapType: MapType.normal,
        initialCameraPosition: widget.state.cameraPosition, // Posicion inicial del mapa
        markers: Set<Marker>.of(widget.state.markers.values), // Marcadores
        polylines: Set<Polyline>.of(widget.state.polylines.values), // Ruta de origen a destino
        myLocationEnabled: false, // Icono de ubicacion predeterminado
        myLocationButtonEnabled: false, // Boton de accion para ir a la posicion del usuario
        compassEnabled: false, // Brujula
        zoomControlsEnabled: false, // Flechas al hacer zoom
      ),
    );
  }

  Widget _draggableCardBookingInfo(BuildContext context, BoxConstraints constraints) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3, // Tamaño inicial (10% de la pantalla)
      minChildSize: 0.3, // Tamaño contraído (90% oculto)
      maxChildSize: 0.4, // Tamaño expandido (50% de la pantalla)
      builder: (context, scrollController) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 186, 186, 186),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 35), // Espacio para el indicador
                      _cardBookingInfoExpanded(context),
                      const SizedBox(height: 15),
                      _actionButton(context),
                      const SizedBox(height: 30), // Espacio adicional para contenido extra
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTripInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.my_location,
                  color: Color(0xFF3b82f6),
                ),
                title: Text(
                  widget.state.pickUpText,
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: Color(0xFFdc2627),
                ),
                title: Text(
                  widget.state.destinationText
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBookingInfoExpanded(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          // Hora y costo
          Row(
            children: [
              const Text(
                'Hora de inicio',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.schedule_rounded, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.state.departureTime != null
                    ? DateFormat.Hm().format(DateTime.parse(widget.state.departureTime!))
                    : '',
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(width: 16),

              const Text(
                'Costo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.attach_money_rounded, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.state.compensation.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          
          Row(
            children: [
              // Imagen del auto con personas
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset(
                  'lib/assets/img/car_logo_person.webp',
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),
          
              // Información del viaje
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y calificación
                    Row(
                      children: [
                        Text(
                          '${widget.state.driver?.name} ${widget.state.driver?.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFF60C3C3),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(6,879)',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
          
                    // Auto y patente
                    Text(
                      '${widget.state.vehicle?.brand} ${widget.state.vehicle?.model} - ${widget.state.vehicle?.patent}',
                      // 'Ford Fiesta - AD542ZY',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
          
                    // Seguro Total
                    Row(
                      children: [
                        Text(
                          'Seguro ${widget.state.vehicle?.insuranceType}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          color: Colors.blue[600],
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () async {
              // Abriendo el modal para elegir el metodo de pago
              final selectedPayment = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => PaymentMethod(
                  selectedMethod: widget.state.paymentMethodSelected, // Pasamos el método actual
                ),
              );

              // Si selectedPayment es null, asignamos un valor por defecto
              final selectedPaymentToUse = selectedPayment ?? PaymentMethodModel.defaultMethod();

              print(selectedPaymentToUse.key);

              // Update Payment Method Function
              context.read<TripAvailableDetailBloc>().add(SelectPaymentMethod(paymentSelected: selectedPaymentToUse));
            },
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(widget.state.paymentMethodSelected.image, fit: BoxFit.contain),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    widget.state.paymentMethodSelected.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),

                  const Spacer(),
              
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.black,
                  ),
                ]
              ) 
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(context) {
    return CustomButton(
      text: widget.state.paymentMethodSelected.key == "CASH" ? 'Reservar' : 'Continuar',
      onPressed: () {
        if (widget.state.paymentMethodSelected.key == "CASH") {
          CustomDialog(
            context: context,
            title: 'Estás por reservar este Viaje. ¿Querés confirmarlo?',
            content: 'Podés cancelar tu reserva hasta 30 minutos antes de su comienzo.',
            icon: Icons.check_circle_rounded,
            onPressedSend: () {
              widget.onReserve?.call(null, null, null, null);
            },
            textSendBtn: 'Reservar',
            textCancelBtn: 'Cancelar',
          );
        } else if (widget.state.paymentMethodSelected.key == "OtherCard") {
          RegisterCardDialog(
            context: context,
            onReserveSeat: true,
            onPressedAfterSuccess: (String cardNumber, String cardHolder, String expiryDate, String cvv) {
              widget.onReserve?.call(cardNumber, cardHolder, expiryDate, cvv);
            },
          );
        } else {
          CustomDialog(
            context: context,
            title: 'Estás por pagar y reservar este Viaje. ¿Querés confirmarlo?',
            content: 'Podés cancelar tu reserva hasta 30 minutos antes de su comienzo.',
            icon: Icons.check_circle_rounded,
            onPressedSend: () {
              widget.onReserve?.call(null, null, null, null);
            },
            textSendBtn: 'Pagar y Reservar',
            textCancelBtn: 'Cancelar',
          );
        }
      },
      margin: const EdgeInsets.only(
        right: 40,
        left: 40,
        bottom: 20
      ),
    );
  }

  /** Funcion para buscar la imagen del metodo de pago seleccionado
   * Este metodo es para encontrar la imagen que corresponde según el método seleccionado
   * Si el método es el Nro de una Tarjeta, se calcula la imagen según las reglas de Visa, Mastercard y Amex
   */
  // String getPaymentImage(String paymentMethod) {
  //   // Diccionario de imágenes
  //   final Map<String, String> paymentImages = {
  //     "CASH": 'lib/assets/img/cash-money-icon.png',
  //     "Mercado Pago": 'lib/assets/img/card-MercadoPago-logo.png',
  //     "OtherCard": 'lib/assets/img/debit-credit-card-logo.png',
  //   };

  //   // Si el método de pago es uno conocido, devuelves la imagen directamente
  //   if (paymentImages.containsKey(paymentMethod)) {
  //     return paymentImages[paymentMethod]!;
  //   }

  //   // Si no es efectivo ni Mercado Pago, chequeamos si es una tarjeta
  //   // Primero, limpiamos los espacios del número de tarjeta
  //   String cardNumber = paymentMethod.replaceAll(" ", "");

  //   // Ahora, evaluamos el número de tarjeta según las reglas de Visa, Mastercard y Amex
  //   if (cardNumber.startsWith('4')) {
  //     return 'lib/assets/img/card-Visa-logo.png'; // Visa
  //   } else if (cardNumber.startsWith(RegExp(r'5[1-5]')) || (int.tryParse(cardNumber.substring(0, 4))! >= 2221 && int.tryParse(cardNumber.substring(0, 4))! <= 2720)) {
  //     return 'lib/assets/img/card-Mastercard-logo.png'; // Mastercard
  //   } else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
  //     return 'lib/assets/img/card-Amex-logo.png'; // American Express
  //   }

  //   // Si no coincide con ninguna de las anteriores, se puede devolver una imagen predeterminada o vacío
  //   return 'lib/assets/img/cash-money-icon.png'; // Imagen predeterminada
  // }

}