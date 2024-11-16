import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/tripAvailableDetailState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomDialog.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripAvailableDetailContent extends StatelessWidget {
  
  TripAvailableDetailState state;
  final VoidCallback onReserve;
  
  TripAvailableDetailContent(this.state, {required this.onReserve, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand, // Esto asegura que el Stack ocupe todo el espacio disponible
      children: [
        _googleMaps(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Esto asegura que el Column ocupe el espacio mínimo necesario
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            _buildTripInfoCard(context),
            _cardBookingInfo(context),
          ],) 
        ),
        CustomIconBack(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
          color: Colors.black,
          onPressed: () {
            // Navigator.pop(context);
            context.pop();
          },
        ),
      ],
    );
  }

  // Mostrando la ruta dell viaje
  Widget _googleMaps(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: GoogleMap(  // Mapa de Google
        mapType: MapType.normal,
        initialCameraPosition: state.cameraPosition, // Posicion inicial del mapa
        markers: Set<Marker>.of(state.markers.values), // Marcadores
        polylines: Set<Polyline>.of(state.polylines.values), // Ruta de origen a destino
        myLocationEnabled: false, // Icono de ubicacion predeterminado
        myLocationButtonEnabled: false, // Boton de accion para ir a la posicion del usuario
        onMapCreated: (GoogleMapController controller) {
          // controller.setMapStyle('JSON');
          if (state.controller != null) {
            if (!state.controller!.isCompleted) {
              state.controller?.complete(controller);
            }
          }
        },
      ),
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
                  state.pickUpText,
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
                  state.destinationText
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

  Widget _cardBookingInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.27,
      padding: EdgeInsets.only(
        left: 20, 
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 186, 186, 186),
          ]
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: Image.asset(
                    'lib/assets/img/car_logo_person.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              leading: const Icon(
                                Icons.schedule_rounded,
                              ),
                              title: Text(
                                state.departureTime != null ? DateFormat.Hm().format(DateTime.parse(state.departureTime!)) : '',
                              ),
                              titleTextStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              leading: const Icon(
                                Icons.attach_money_rounded,
                                // color: Color(0xFFdc2627),
                              ),
                              title: Text(
                                state.compensation.toString(),
                                // '1000'
                              ),
                              titleTextStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    ListTile(
                      title: Text(
                        // 'Conductor: Juan Mantese',
                        'Conductor: ${state.driver?.name} ${state.driver?.lastName}',
                        style: const TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Botón para confirmar los datos del viaje y crear el viaje.
          const Spacer(),
          CustomButton(
            text: 'Reservar',
            onPressed: () {
              CustomDialog(
                context: context,
                title: 'Estás por reservar este Viaje. ¿Querés confirmarlo?',
                content: 'Podés cancelar tu reserva hasta 30 minutos antes de su comienzo.',
                icon: Icons.check_circle_rounded,
                onPressedSend: onReserve,
                textSendBtn: 'Reservar',
                textCancelBtn: 'Cancelar',
              );
            },
            margin: const EdgeInsets.only(
              right: 40,
              left: 40,
              bottom: 20
            ),
          ),
        ],
      )
    );
  }
}