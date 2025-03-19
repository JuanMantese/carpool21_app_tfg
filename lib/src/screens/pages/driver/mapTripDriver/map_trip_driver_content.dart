import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_state.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// PANTALLA DONDE EL PASAJERO VERA EL RECORRIDO DEL VIAJE EN TIEMPO REAL
class MapTripDriverContent extends StatelessWidget {
  
  final MapTripDriverState state;
  final TripDetail tripDetail;

  const MapTripDriverContent(
    this.state,
    this.tripDetail,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double draggableHeight = constraints.maxHeight * 0.06; // Altura cuando el draggable está contraído
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: draggableHeight,
              child: _googleMaps(context),
            ),
            CustomIconBack(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
              color: Colors.black,
              onPressed: () {
                context.pop();
              },
            ),
            _draggableCardBookingInfo(context),
          ],
        );
      },
    );
  }

  // Mostrando el viaje en tiempo real
  Widget _googleMaps(BuildContext context) {
    return GoogleMap( // Mapa de Google
      mapType: MapType.normal,
      initialCameraPosition: state.cameraPosition, // Posicion inicial del mapa
      markers: Set<Marker>.of(state.markers.values),  // Marcadores
      polylines: Set<Polyline>.of(state.polylines.values), // Ruta de origen a destino
      myLocationEnabled: false, // Icono de ubicacion predeterminado
      myLocationButtonEnabled: false, // Boton de accion para ir a la posicion del usuario
      onMapCreated: (GoogleMapController controller) {
        if (state.controller != null) {
          if (!state.controller!.isCompleted) {
            state.controller?.complete(controller);
          }
        }
      },
    );
  }
  
  Widget _draggableCardBookingInfo(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1, // Tamaño inicial (10% de la pantalla)
      minChildSize: 0.1, // Tamaño contraído (90% oculto)
      maxChildSize: 0.5, // Tamaño expandido (50% de la pantalla)
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
                      const SizedBox(height: 30), // Espacio para el indicador

                      _primaryInfo(),

                      _locationInfo(),

                      _buildPassengersList(tripDetail.reservations!),

                      const SizedBox(height: 15),
                      _actionButton(context),
                      const SizedBox(height: 50), // Espacio adicional para contenido extra
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10, // Ajusta la posición
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

  Widget _primaryInfo() {
    return Container(
      padding: const EdgeInsets.only(right: 16.0), // Espaciado interno opcional
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // Alineación vertical
        children: [
          Expanded(
            child: ListTile(
              isThreeLine: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tripDetail.driver?.name} ${tripDetail.driver?.lastName}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${tripDetail.vehicle?.patent}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              subtitle: Text(
                '${tripDetail.vehicle?.brand} ${tripDetail.vehicle?.model} | ${tripDetail.vehicle?.color}',
                style: const TextStyle(fontSize: 13),
              ),
              leading: SizedBox(
                height: 80,
                width: 60, // Asegura suficiente ancho para ambas imágenes
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(
                    'lib/assets/img/car_logo_person.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: 53,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Fondo gris
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Espaciado interno
            child: Center(
              child: state.timeAndDistance != null
                ? Text(
                    '${state.timeAndDistance?.distance.text}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                    Icons.access_time, // Mostrar ícono de reloj si es null
                    size: 24,
                    color: Colors.black,
                  ),
            ) 
          ),

          const SizedBox(width: 10),
          
          Container(
            width: 53,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Fondo gris
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Espaciado interno
            child: Center(
              child: state.timeAndDistance != null
                ? Text(
                    '${state.timeAndDistance?.duration.text}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                  Icons.access_time, // Mostrar ícono de reloj si es null
                  size: 24,
                  color: Colors.black,
                ),
            ) 
          ),
        ],
      ),
    );
  }

  Widget _locationInfo() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Recoger en',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            tripDetail.pickupText,
            style: const TextStyle(fontSize: 13),
          ),
          leading: const Icon(
            Icons.my_location,
            color: Color(0xFF3b82f6),
          ),
        ),
        ListTile(
          title: const Text(
            'Dejar en',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            tripDetail.destinationText,
            style: const TextStyle(fontSize: 13),
          ),
          leading: const Icon(
            Icons.location_on,
            color: Color(0xFFdc2627),
          ),
        ),
        // ListTile(
        //   title: const Text(
        //     'Distancia y tiempo aproximado',
        //     style: TextStyle(fontSize: 15),
        //   ),
        //   subtitle: Text(
        //     '${tripDetail.distance} ${tripDetail.timeDifference}',
        //     style: const TextStyle(fontSize: 13),
        //   ),
        //   leading: const Icon(Icons.timer),
        // ),
      ],
    );
  }

  Widget _buildPassengersList(List<Reservations> reservations) {  
    // Permite listar la informacion que viene dentro de una Lista
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pasajeros',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Color(0xFF00A48B),
          ),
        ),
        const SizedBox(height: 10),
          Column(
          children: reservations.map((reserve) {
            return _passengerItem(
              reserveDetail: reserve,
            );
          }).toList()
        )
      ],
    );
  }

  Widget _passengerItem({
    required reserveDetail,
  }) {
    return Card(
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
              child: Text(
                '${reserveDetail.passenger.name} ${reserveDetail.passenger.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF006D59),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: reserveDetail.isPaid 
                  ? const Color.fromARGB(41, 0, 169, 144) 
                  : const Color.fromARGB(34, 206, 79, 0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reserveDetail.isPaid ? 'Pagado' : 'Pendiente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: reserveDetail.isPaid 
                    ? const Color.fromARGB(255, 0, 145, 123)
                    : const Color.fromARGB(255, 250, 96, 0),
                ),
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

  Widget _actionButton(BuildContext context) {
    return OutlinedButton(
      onPressed: state.isArrived
        ? () {
            context.read<MapTripDriverBloc>().add(ChangeTripStatus(idTrip: tripDetail.idTrip));
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
          return const Color(0xFF00A98F);
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
        'Finalizar Viaje',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

}