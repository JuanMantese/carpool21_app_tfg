import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailState.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/tripDetailReservesItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripDetailContent extends StatelessWidget {
  
  TripDetail? tripDetail;
  TripDetailState state;
  
  TripDetailContent(this.tripDetail, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    print('TripDetailContent');
    // print(tripDetail?.reservations?[0].passenger?.name);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 26,
            // bottom: MediaQuery.of(context).padding.bottom + 26,
            right: 26,
            left: 26
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripCard(context),
              const SizedBox(height: 16),
              _buildTripInfoMap(context),
              const SizedBox(height: 16),
              _buildObservationsSection(context),
              const SizedBox(height: 16),
              _buildVehicleInfo(context),
              const SizedBox(height: 16),
              _buildReservesList(context),
              const SizedBox(height: 16),            
              const Spacer(),
              _buttonsAction(context)
              
            ],
          ),
        ),
        
        _headerTripDetail(context),
        CustomIconBack(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
          onPressed: () {
            // Navigator.pushNamedAndRemoveUntil(context, '/driver/home', (Route<dynamic> route) => false,);
            context.go('/driver/0');
          },
        ),
      ],
    );
  }

  Widget _headerTripDetail(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
      height: MediaQuery.of(context).size.height * 0.16,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 64, 52), // Top color
            Color(0xFF00A48B), // Bottom color
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Text(
        'DETALLE DEL VIAJE',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 20,
        right: 5,
        left: 5
      ),
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
                tripDetail != null ? tripDetail!.pickupNeighborhood : '',
              ),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
              subtitle: Text(
                tripDetail != null ? tripDetail!.pickupText : '',
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Color(0xFFdc2627),
              ),
              title: Text(
                tripDetail != null ? tripDetail!.destinationNeighborhood : ''
              ),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
              subtitle: Text(
                tripDetail != null ? tripDetail!.destinationText : ''
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoMap(BuildContext context) {
    final formattedTime = DateFormat.Hm().format(DateTime.parse(tripDetail!.departureTime));

    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.timer,
                    // color: Color(0xFF3b82f6),
                  ),
                  title: Text(
                    tripDetail != null ? formattedTime : '',
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_rounded,
                    // color: Color(0xFF3b82f6),
                  ),
                  title: Text(
                    tripDetail != null ? tripDetail!.availableSeats.toString() : '',
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                  ),
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.attach_money_rounded,
                //     // color: Color(0xFFdc2627),
                //   ),
                //   title: Text(
                //     tripDetail != null ? tripDetail!.compensation.toString() : ''
                //   ),
                //   titleTextStyle: const TextStyle(
                //     fontSize: 14,
                //     color: Colors.black
                //   ),
                // ),
            
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2, // Expansión de la sombra
                    blurRadius: 6, // Desenfoque de la sombra
                    offset: Offset(0, 3), // Desplazamiento de la sombra
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: state.cameraPosition,
                  markers: Set<Marker>.of(state.markers.values),
                  polylines: Set<Polyline>.of(state.polylines.values),
                  onMapCreated: (GoogleMapController controller) {
                    if (state.controller != null) {
                      if (!state.controller!.isCompleted) {
                        print('Aca entra');
                        state.controller?.complete(controller);
                      }
                    }
                    print('No entro ');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsSection(BuildContext context) {
    return (tripDetail?.observations != null && tripDetail!.observations!.isNotEmpty) ? 
      Container(
        margin: const EdgeInsets.only(
          right: 5,
          left: 5
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Observaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF00A48B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // 'Observaciones Description',
                  tripDetail != null ? tripDetail!.observations! : '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
      : 
      Container(
        margin: const EdgeInsets.only(top: 16, bottom: 40),
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: const Text("No hay observaciones disponibles."),
      );
  }

  Widget _buildVehicleInfo(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      elevation: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: Image.asset(
                    'lib/assets/img/car_logo_top.png',
                    fit: BoxFit.cover,
                  ),
                ),
                
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tripDetail?.vehicle?.brand ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Patente: ${tripDetail?.vehicle?.patent ?? ''}'),
                      Text('Año: ${tripDetail?.vehicle?.year ?? ''}'),
                      Text('Color: ${tripDetail?.vehicle?.color ?? ''}'),
                      // Text('Cédula Verde: ${tripDetail?.vehicle?.nroGreenCard ?? ''}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservesList(BuildContext context) {  
    // Permite listar la informacion que viene dentro de una Lista
    return (tripDetail?.reservations != [] && tripDetail!.reservations!.isNotEmpty) ? 
      Column(
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
          ...tripDetail!.reservations!.map((reserve) {
            return TripDetailReservesItem(reserveDetail: reserve);
          }).toList(),
        ],
      )
      : 
      Container(
        margin: const EdgeInsets.only(top: 16, bottom: 40),
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: const Text("No hay reservas disponibles."),
      );
  }

  Widget _buttonsAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 26,),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    backgroundColor: const Color(0xFFF9F9F9),
                    elevation: 0,
                    side: const BorderSide(
                      color: Color(0xFFdc2627),
                      width: 2.0
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: Color(0xFFdc2627),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFFdc2627),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    backgroundColor: const Color(0xFFF9F9F9),
                    elevation: 0,
                    side: const BorderSide(
                      color: Color(0xFF00A98F),
                      width: 2.0
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF00A98F),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Editar',
                        style: TextStyle(
                          color: Color(0xFF00A98F),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 0,
                  right: 0,
                  bottom: 10,
                ),
                backgroundColor: const Color(0xFFF9F9F9),
                elevation: 0,
                side: const BorderSide(
                  color: Color.fromRGBO(0, 66, 142, 0.659),
                  width: 2.0
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                disabledBackgroundColor: Color.fromARGB(170, 217, 198, 198),
                disabledForegroundColor: Color.fromARGB(255, 108, 100, 100),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.close_rounded,
                  //   color: Color.fromRGBO(0, 117, 255, 0.66),
                  // ),
                  // SizedBox(width: 16),
                  Text(
                    'Iniciar Viaje',
                    style: TextStyle(
                      // color: Colors.black,
                        // Color.fromRGBO(0, 163, 255, 0.43), // Top color
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}