// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_state.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:carpool_21_app/src/screens/widgets/image_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// PANTALLA DONDE EL PASAJERO VERA EL RECORRIDO DEL VIAJE EN TIEMPO REAL
class MapTripPassengerContent extends StatelessWidget {
  
  final MapTripPassengerState state;
  final ReserveDetail reserveDetail;

  const MapTripPassengerContent(
    this.state,
    this.reserveDetail,
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
                      const SizedBox(height: 35), // Espacio para el indicador
                      _primaryInfo(),
                      _timeInfo(),
                      _locationInfo(),
                      const SizedBox(height: 15),
                      _actionButton(context),
                      const SizedBox(height: 30), // Espacio adicional para contenido extra
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
                    '${reserveDetail.driver.name} ${reserveDetail.driver.lastName}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${reserveDetail.tripRequest.vehicle?.patent}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              subtitle: Text(
                '${reserveDetail.tripRequest.vehicle?.brand} ${reserveDetail.tripRequest.vehicle?.model} | ${reserveDetail.tripRequest.vehicle?.color}',
                style: const TextStyle(fontSize: 13),
              ),
              leading: SizedBox(
                height: 80,
                width: 110, // Asegura suficiente ancho para ambas imágenes
                child: Stack(
                  clipBehavior: Clip.none, // Permite que los widgets se desborden
                  children: [
                    Positioned(
                      top: 0, 
                      left: 50, // Ajusta para desplazar la primera imagen
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset(
                          'lib/assets/img/car_logo_person.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: ImageUser(
                          urlImg: 'https://lh3.googleusercontent.com/fife/ALs6j_GUNUZAmJJ2p-J9avylOcBQ9VLhtxmDLQur4B-x5qi49xRFetc8yO2eDnAoLktheYMrMYC0tDECkO37Ljrk2UfNG8d5FhjicsdWXEptuuHgv6SGLIj0SIpzyMFila5hzDXJGmOAMQBL_RsV2XInu-TYYPnnvvTIWhIaRgL4A6RCEOgnsZgy2cX9tW_x0ebkL3G_C7F9192Up-apqb7Rq_AB15-cWC1KzrCtIu8S3MFp3UUMJ_ZoH0ddRmPJuRJ9VAR8jkfkLM59bCvJfdu1EymY-HJC8VnlXFo0DrDZafSDedqO5u7NVLxcSwtxdJRcq92z-qpnMK9Cx0Jig2w224YZUwi3p3UJMlr-3JWwdYansYuPC42RA4F8CJRivN6OdDRCwXgFj3sjMXoW3dhKsrMOj7RlLMbN3NqvM4qbN-WPaG5gK_LXBDfwd2J7uTzk54J9C4RMHw-d-wA6zsm_OpfsgT2ELIgM7djGhTKLYTd2HB5BSD2HjJoysHPekGe7xJoIHYHWwppxNoGDuP4K3IZQgRBAwjpQeiUteeKLEUhY2RVrzHcL0LmBfU-1dFIe_2WfgkZYRQyXfpcsiNnrinV9hYoliE0W3qt1eLBxOv3niTc9kpfa5pXbC2VxsqGUIu19BtcOSych1VzZy1K3HsjOm0ji5ZqBB2n0vHPkqF1RIuneGsLVtN7xAm5Q_1c0x5w28xWgvzwkVqB8qvCUXldUKd7HAj41QMlLYFT0OW7spmhQ6I1lRMrXMFxTf9lQRBETAbrG7wepfpEwe08qK7NyeXsT0_2rs5E8HYYV6tUqLkRSAs5nQ78FME2W6yECv2fPfMgHeanJld_U9U55_ZOF7KCRcqin5St4hJRFP5ieH7HAyyJcWJc_Mbol0bJXdkTXvHiCc9TAtgXbJ7WhQadjZRzAYkdhPF231xSRFnrPYlfbDODjMykZt5M7ZutpPT5GeoHZ624oznwRnBzLhUB2Lvpt7WSUm4sxULLJu92lrv0cqD9qZyaY8D5w1DplR4gV7VgbbAXfWh48doZsAIiVpNpYtAvvFFuRGZ8xT3A8jdkGUq6OkrbM0HDRPQ5F0h1vGmbhchdCkYyBjpBrSFxan3TIzovOU7rtPI2ir5flYyfmYqUoOptd4jcj4EYdyYafRqo5MFerVOYxsEJzA5jt5Iz100Fequ1FBbX5OWnrxlcKkxr7dEHED9-asxqNlW0T8Waw6Gjy0VidwPqC85dUszkdYvKVI887ixvqRhg3TthD7tHzD-Y1Rhw63Alc9TavlBUGsInkjDTCOwLYS1Us-iFbd9SF0YGunVaYQUPWen0_rJw5vwzzaThNmKwyD-gzsf2IEZ9G0h_s4fRBlX9usiaUGcQ9Fm8GNEYNC1BCCQYSwaDBiZyecePFnRaAHO0XypiGfMnlqip6aBMca-HO6NWsSuNfrfxuU_7RCp4SN7QXz7cEUUL1vwoEYeEXOazSvhMfiLOokm1IR2ycluXYuglj9a_7V-ceEnqbTyElbq1HkBxaym72XCNE-ouiyzPdMGcjmv3ZRjXq_FyaNeqsARygVklKv1j8DdeivkKjTrQ1hXu_ImHeW6aZn4-W10Whlw88X7x9TQP6=w3440-h1780',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: 53,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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

  Widget _timeInfo() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tiempo estimado de llegada',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 6),
      
          Center(
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
        ]
      ) 
    );
  }

  Widget _locationInfo() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Lugar de Origen',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            reserveDetail.tripRequest.pickupText,
            style: const TextStyle(fontSize: 13),
          ),
          leading: const Icon(
            Icons.my_location,
            color: Color(0xFF3b82f6),
          ),
        ),
        ListTile(
          title: const Text(
            'Lugar de Destino',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            reserveDetail.tripRequest.destinationText,
            style: const TextStyle(fontSize: 13),
          ),
          leading: const Icon(
            Icons.location_on,
            color: Color(0xFFdc2627),
          ),
        ),
        ListTile(
          title: const Text(
            'Pago',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            // reserveDetail.tripRequest.destinationText,
            'Efectivo',
            style: const TextStyle(fontSize: 13),
          ),
          leading: const Icon(
            Icons.payments,
            color: Color(0xFF00A98F),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: state.isPaid 
                ? const Color.fromARGB(41, 0, 169, 144) 
                : const Color.fromARGB(34, 206, 79, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.isPaid ? 'Pagado' : 'Pendiente',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: state.isPaid 
                  ? const Color.fromARGB(255, 0, 145, 123)
                  : const Color.fromARGB(255, 250, 96, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(context) {
    return OutlinedButton(
      onPressed: !state.isPaid
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
        'Pagar Viaje',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

}