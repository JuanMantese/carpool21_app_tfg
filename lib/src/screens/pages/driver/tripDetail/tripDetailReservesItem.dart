
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:flutter/material.dart';

class TripDetailReservesItem extends StatelessWidget {

  Reservations reserveDetail;

  TripDetailReservesItem({required this.reserveDetail, super.key});

  // Card para mostrar la informacion de los pasajeros que reservaron un viaje
  @override
  Widget build(BuildContext context) {
    return 
    // GestureDetector(
      // onTap: () {
      //   FareOfferedDialog(
      //     context, 
      //     () {
      //       if (clientRequest != null && state.idDriver != null && context.read<DriverClientRequestsBloc>().state.fareOffered.value.isNotEmpty) {
      //         context.read<DriverClientRequestsBloc>().add(
      //           CreateDriverTripRequest(
      //             driverTripRequest: DriverTripRequest(
      //               idDriver: state.idDriver!, 
      //               idClientRequest: clientRequest!.id, 
      //               fareOffered: double.parse(context.read<DriverClientRequestsBloc>().state.fareOffered.value), 
      //               time: clientRequest!.googleDistanceMatrix!.duration.value.toDouble() / 60, 
      //               distance: clientRequest!.googleDistanceMatrix!.distance.value.toDouble() / 1000, 
      //             )
      //           )
      //         );
      //       }
      //       else {
      //         Fluttertoast.showToast(msg: 'No se puede enviar la oferta', toastLength: Toast.LENGTH_LONG);
      //       }
      //   });
      // },
      // child: 
      Card(
        color: const Color.fromRGBO(0, 164, 139, 0.09),
        elevation: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ListTile(
                  leading: _imageUser(),
                  title: Text(
                    '${reserveDetail.passenger?.name} ${reserveDetail.passenger?.lastName}',
                    style: const TextStyle(
                      color: Color(0xFF006D59),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: ListTile(
                  title: Text('4.5'),
                ),
              ),
            ],
          ),
        ),
      );
    // );
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
}