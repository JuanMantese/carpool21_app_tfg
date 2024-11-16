import 'package:carpool_21_app/src/screens/pages/carInfo/list/carItem.dart';
import 'package:carpool_21_app/src/screens/pages/driver/trips/tripsItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomDialogTrip.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class DriverHomeContent extends StatelessWidget {

  DriverHomeViewState state;

  DriverHomeContent({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _headerHome(context),
      Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 80,
          bottom: 16,
          left: 26,
          right: 26
        ),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Bienvenido nuevamente ${state.user?.name}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF00A48B),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Mis Vehiculos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A48B),
              ),
            ),
            const SizedBox(height: 8),
            
            (state.carList != null
              ? CarItem(car: state.carList![0])
              : _vehicleCard(context)
            ),
            const SizedBox(height: 22),
            
            const Text(
              'Viajes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A48B),
              ),
            ),
            const SizedBox(height: 8),
            (state.driverTripAll != null &&
              state.driverTripAll?.futureTrips != null &&
              state.driverTripAll!.futureTrips!.isNotEmpty
                ? TripsItem(
                    state.driverTripAll?.futureTrips?[0], 'futureTrips')
                : _tripsCard(context)
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _headerHome(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.21,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            // Color.fromARGB(255, 109, 11, 0), // Top color
            Color.fromARGB(255, 0, 73, 60), // Top color
            Color(0xFF00A48B), // Bottom color
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A48B).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 10), // Shadow offset distance in x,y
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 30,
          bottom: 30,
          right: 15,
          left: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/img/Header-Logo-Mini.png',
              height: 85,
              width: 300,
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 36,
                color: Colors.white,
              ),
              onPressed: () {
                print("Notificaciones");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleCard(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: const Color(0xFFF9F9F9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.drive_eta_rounded,
                      size: 50, color: Color(0xFF00A48B)),
                  const SizedBox(width: 16),
                  Container(
                    width: 150,
                    child: Text(
                      'Sin vehículos registrados',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/car/register', arguments: '/driver/home');
                  context.push('/car/list/register', extra: {
                    'originPage': '/driver/0',
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9F9F9),
                  side: const BorderSide(
                    color: Color(0xFF00A98F),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  '+  Nuevo',
                  style: TextStyle(
                    color: Color(0xFF00A98F),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripsCard(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: const Color(0xFFF9F9F9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      size: 50, color: Color(0xFF00A48B)),
                  const SizedBox(width: 16),
                  Container(
                    width: 150,
                    child: Text(
                      'Sin viajes programados',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print("Nuevo viaje");

                  // Verificamos que el usuario tenga al menos 1 vehiculo registrado
                  CustomDialogTrip(
                    context: context,
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9F9F9),
                  side: const BorderSide(
                    color: Color(0xFF00A98F),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  '+  Nuevo',
                  style: TextStyle(
                    color: Color(0xFF00A98F),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
