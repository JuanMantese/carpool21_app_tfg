import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class DialogDriverRatingTrip extends StatefulWidget {
  
  final BuildContext context;
  final TripDetail tripDetail;

  DialogDriverRatingTrip({
    super.key,
    required this.context,
    required this.tripDetail
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  _DialogDriverRatingTripState createState() => _DialogDriverRatingTripState();
}

class _DialogDriverRatingTripState extends State<DialogDriverRatingTrip> {

  final Map<String, double> _ratings = {};
  bool _isChecked = false; 

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.tripDetail.departureTime));
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hola ${widget.tripDetail.driver?.name}!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Cómo estuvo tu viaje del $formattedDate?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ayudanos a seguir promoviendo un servicio seguro y de calidad dejando tu calificación del viaje.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          _buildPassengersList(widget.tripDetail.reservations ?? []),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
                activeColor: const Color(0xFF00A98F),
              ),
              const Expanded(
                child: Text(
                  'Aceptar conformidad del viaje',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
      
      actions: <Widget>[
        ButtonBar(
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Aquí puedes procesar la calificación, opciones seleccionadas y comentario
                print(_ratings);
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF00A98F),
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Enviar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: _isChecked
                ? () {
                    // Aquí se procesa la cancelación de calificación
                    print("Calificación cancelada.");
                    Navigator.of(context).pop();
                  }
                : null,
              style: ButtonStyle(
                // backgroundColor: const Color(0xFF00A98F),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  // Si el botón está deshabilitado
                  if (states.contains(MaterialState.disabled)) {
                    return const Color.fromARGB(255, 187, 187, 187);
                  }
                  // Si el botón está habilitado
                  return Colors.transparent;
                }),
                side: MaterialStateProperty.resolveWith<BorderSide>((states) {
                  // Si el botón está deshabilitado
                  if (states.contains(MaterialState.disabled)) {
                    return const BorderSide(color: Colors.grey);
                  }
                  // Si el botón está habilitado
                  return const BorderSide(color: Color(0xFF00A98F));
                }),
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              child: const Text(
                'No calificar',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengersList(List<Reservations> reservations) {  
    // Permite listar la informacion que viene dentro de una Lista
    return Column(
      children: reservations.map((reserve) {
        return _passengerItem(
          passengerDetail: reserve.passenger!,
          onRatingUpdate: (rating) {
            setState(() {
              _ratings[reserve.passenger!.name] = rating;
            });
          },
        );
      }).toList()
    );
  }

  Widget _passengerItem({
    required Passenger passengerDetail,
    required Function(double) onRatingUpdate,
  }) {
    return 
      Card(
        color: const Color.fromRGBO(0, 164, 139, 0.09),
        elevation: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageUser(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${passengerDetail.name} ${passengerDetail.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF006D59),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), 
                    _ratingBar(onRatingUpdate: onRatingUpdate),
                  ],
                ),
              ),
            ]
          )
        ),
      );
  }

  // Imagen del Pasajero
  Widget _imageUser() {
    return SizedBox(
      width: 50,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: Image.asset(
              'lib/assets/img/profile-icon.png',
            ),
        ),
      ),
    );
  }
  

  Widget _ratingBar({
    required Function(double) onRatingUpdate,
  }) {
    return RatingBar.builder(
      itemBuilder: (context, _) => Icon( // El context se utiliza, el segundo parametro no
        Icons.star,
        color: Colors.amber[700],
      ),
      itemSize: 30.0,
      initialRating: 0, // Valor inicial
      itemCount: 5, // Cantidad de elementos
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: const Color.fromARGB(255, 155, 155, 155),
      onRatingUpdate: onRatingUpdate
    );
  }

}