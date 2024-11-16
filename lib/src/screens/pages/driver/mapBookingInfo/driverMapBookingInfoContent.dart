import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// PANTALLA DONDE EL PASAJERO VA A VER EL RECORRIDO QUE HACE EL VIAJE QUE ESTA CONSULTANDO
class DriverMapBookingInfoContent extends StatelessWidget {
  
  DriverMapBookingInfoState state;
  TimeAndDistanceValues timeAndDistanceValues;

  DriverMapBookingInfoContent(this.state, this.timeAndDistanceValues, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _googleMaps(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: _cardBookingInfo(context),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.64,
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
              print('ACA ENTRA');
              state.controller?.complete(controller);
            }
          }
          print('NO ENTRO');
        },
      ),
    );
  }

  Widget _cardBookingInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.39,
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
          ListTile(
            title: const Text(
              'Recoger en',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            subtitle: Text(
              state.pickUpText,
              style: const TextStyle(
                fontSize: 13
              ),
            ),
            leading: const Icon(
              Icons.my_location,
              color: Color(0xFF3b82f6),
            ),
          ),

          ListTile(
            title: const Text(
              'Dejar en',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            subtitle: Text(
              state.destinationText,
              style: const TextStyle(
                fontSize: 13
              ),
            ),
            leading: const Icon(
              Icons.location_on,
              color: Color(0xFFdc2627),
            ),
          ),

          ListTile(
            title: const Text(
              'Tiempo y distancia aproximados',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            subtitle: Text(
              '${timeAndDistanceValues.distance.text} y ${timeAndDistanceValues.duration.text}',
              style: const TextStyle(
                fontSize: 13
              ),
            ),
            leading: const Icon(Icons.timer),
          ),

          // ListTile(
          //   title: const Text(
          //     'Precio',
          //     style: TextStyle(
          //       fontSize: 15
          //     ),
          //   ),
          //   subtitle: Text(
          //     '\$${timeAndDistanceValues.tripPrice}',
          //     style: const TextStyle(
          //       fontSize: 13
          //     ),
          //   ),
          //   leading: const Icon(
          //     Icons.money,
          //     color: Color.fromARGB(255, 23, 135, 52),
          //   ),
          // ),

          // Botón para confirmar los datos del viaje y crear el viaje.
          const Spacer(),
          CustomButton(
            text: 'Confirmar recorrido',
            onPressed: () {
              // Navigator.pushNamed(context, '/driver/createTrip',
              //   arguments: {
              //     'pickUpNeighborhood': state.pickUpNeighborhood,
              //     'pickUpText': state.pickUpText,
              //     'pickUpLatLng': state.pickUpLatLng,
              //     'destinationNeighborhood': state.destinationNeighborhood,
              //     'destinationText': state.destinationText,
              //     'destinationLatLng': state.destinationLatLng,
              //     'departureTime': state.departureTime,
              //     'timeAndDistanceValues': timeAndDistanceValues,
              //     'state': state,
              //   }
              // );

              context.push('/driver/0/createTrip', extra: {
                'pickUpNeighborhood': state.pickUpNeighborhood,
                'pickUpText': state.pickUpText,
                'pickUpLatLng': state.pickUpLatLng,
                'destinationNeighborhood': state.destinationNeighborhood,
                'destinationText': state.destinationText,
                'destinationLatLng': state.destinationLatLng,
                'departureTime': state.departureTime,
                'timeAndDistanceValues': timeAndDistanceValues,
                'state': state,
              });
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