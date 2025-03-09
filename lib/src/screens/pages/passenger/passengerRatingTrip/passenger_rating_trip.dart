import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class DialogPassengerRatingTrip extends StatefulWidget {
  
  final BuildContext context;
  final ReserveDetail tripReservationDetail;

  DialogPassengerRatingTrip({
    super.key,
    required this.context,
    required this.tripReservationDetail
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

    @override
  _DialogPassengerRatingTripState createState() => _DialogPassengerRatingTripState();
}

class _DialogPassengerRatingTripState extends State<DialogPassengerRatingTrip> {

  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  final List<String> _positiveOptions = [
    "Cumplimiento del viaje",
    "Conducción responsable",
    "Puntualidad",
    "Amabilidad",
    "A tiempo",
  ];

  final List<String> _negativeOptions = [
    "Impuntual",
    "Comportamiento inapropiado",
    "Conducción temeraria",
    "Vehículo en mal estado",
    "Cancelación del viaje a último momento",
  ];

  final List<String> _selectedOptions = [];


  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.tripReservationDetail.tripRequest.departureTime));
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // title: const Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Icon(
      //       Icons.directions_car_rounded,
      //       size: 40,
      //       color: Color(0xFF006D59),
      //     ),
      //     SizedBox(height: 10),
      //     Text(
      //       'Elegí tu ruta!',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ],
      // ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            '¿Cómo estuvo tu viaje del $formattedDate?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          _driverInfo(),
          const SizedBox(height: 10),
          const Text(
            'Ayudanos a seguir promoviendo un servicio seguro y de calidad dejando tu calificación del viaje.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          _ratingBar(),
          const SizedBox(height: 20),
          _buildSelectableOptions(),
          const SizedBox(height: 20),
          _commentField(),

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
          ],
        ),
      ],
    );
  }

  Widget _driverInfo() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 30,
          bottom: 16, 
          right: 16, 
          left: 30,
        ), 
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage('lib/assets/img/profile-icon.png'),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.tripReservationDetail.driver.name} ${widget.tripReservationDetail.driver.lastName}',
                  style: const TextStyle(
                    color: Color(0xFF006D59),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Perfil',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text(
                          'Vehículo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      itemBuilder: (context, _) => Icon( // El context se utiliza, el segundo parametro no
        Icons.star,
        color: Colors.amber[700],
      ),
      initialRating: 0, // Valor inicial
      itemCount: 5, // Cantidad de elementos
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: const Color.fromARGB(255, 155, 155, 155),
      onRatingUpdate: (rating) { // Devuelve la calificación que selecciono el el usuario en formato de Nro
        setState(() {
          _rating = rating;
          _selectedOptions.clear(); // Reinicia las opciones seleccionadas
        });
      }
    );
  }

  Widget _buildSelectableOptions() {
    final options = _rating >= 2.5 ? _positiveOptions : _negativeOptions;
    return Wrap(
      spacing: 8,
      runSpacing: 0,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        return FilterChip(
          label: Text(
            option,
            style: const TextStyle(fontSize: 12), 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          selected: _selectedOptions.contains(option),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                _selectedOptions.add(option);
              } else {
                _selectedOptions.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _commentField() {
    return TextField(
      controller: _commentController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Indicanos el motivo de tu calificación...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

}