import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ReserveDetailContent extends StatelessWidget {

  ReserveDetail? reserveDetail;
  ReserveDetailState state;
  
  ReserveDetailContent(this.reserveDetail, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    print('ReserveDetailContent');

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 26,
            // bottom: MediaQuery.of(context).padding.bottom + 26,
            right: 26,
            left: 26
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _driverInfo(context),
              const SizedBox(height: 16),
              _buildTripInfoMap(context),
              const SizedBox(height: 16),
              _buildObservationsSection(context),
              const SizedBox(height: 16),
              _buildVehicleInfo(context),
              _buildTripCard(context),
              const SizedBox(height: 28),
              _buttonsAction(context)                  
            ],
          ),
        ),

        _headerTripDetail(context),
        CustomIconBack(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
          onPressed: () {
            // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (Route<dynamic> route) => false,);
            context.go('/passenger/0');
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
        'DETALLE DE RESERVA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }

  Widget _driverInfo(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 30,
          right: 16, 
          left: 30,
        ), 
        child: Column(
          children: [
            const Text(
              'Conductor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xFF00A48B),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const CircleAvatar(
                  radius: 26.0,
                  backgroundImage: AssetImage('lib/assets/img/profile-icon.png'),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${reserveDetail?.driver?.name} ${reserveDetail?.driver?.lastName}' ?? 'Juan Mantese Test',
                      style: const TextStyle(
                        color: Color(0xFF006D59),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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

  Widget _buildTripInfoMap(BuildContext context) {
    print(reserveDetail!.tripRequest.timeDifference);
    final formattedTime = DateFormat.Hm().format(DateTime.parse(reserveDetail!.tripRequest.departureTime.toString()));

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
                    Icons.schedule_rounded,
                    // color: Color(0xFF3b82f6),
                  ),
                  title: Text(
                    reserveDetail != null ? formattedTime : '',
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                  ),
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.person_rounded,
                //     // color: Color(0xFF3b82f6),
                //   ),
                //   title: Text(
                //     reserveDetail != null ? reserveDetail!.tripRequest.timeDifference.toString() : '',
                //   ),
                //   titleTextStyle: const TextStyle(
                //     fontSize: 14,
                //     color: Colors.black
                //   ),
                // ),
                ListTile(
                  leading: const Icon(
                    Icons.attach_money_rounded,
                    // color: Color(0xFFdc2627),
                  ),
                  title: Text(
                    reserveDetail != null ? reserveDetail!.tripRequest.compensation.toString() : ''
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black
                  ),
                ),
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
                        state.controller?.complete(controller);
                      }
                    }
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
    return Container(
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
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Observaciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF00A48B),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Encuentro en acceso al edificio Experimenta 21',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
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
                        reserveDetail?.tripRequest.vehicle?.brand ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Patente: ${reserveDetail?.tripRequest.vehicle?.patent ?? ''}'),
                      Text('Año: ${reserveDetail?.tripRequest.vehicle?.year ?? ''}'),
                      Text('Color: ${reserveDetail?.tripRequest.vehicle?.color ?? ''}'),
                      // Text('Cédula Verde: ${reserveDetail?.tripRequest.vehicle?.nroGreenCard ?? ''}'),
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

  Widget _buildTripCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        right: 5,
        left: 5
      ),
      elevation: 2.0,
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
                reserveDetail != null ? reserveDetail!.tripRequest.pickupNeighborhood : '',
              ),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
              subtitle: Text(
                reserveDetail != null ? reserveDetail!.tripRequest.pickupText : '',
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Color(0xFFdc2627),
              ),
              title: Text(
                reserveDetail != null ? reserveDetail!.tripRequest.destinationNeighborhood : ''
              ),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
              subtitle: Text(
                reserveDetail != null ? reserveDetail!.tripRequest.destinationText : ''
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonsAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom,),
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: Size(180, 50),
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
      )
    );
  }
}