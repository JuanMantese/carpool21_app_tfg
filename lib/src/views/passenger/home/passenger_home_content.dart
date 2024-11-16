import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_state.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/reservesItem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PassengerHomeContent extends StatelessWidget {
  final PassengerHomeViewState state;

  const PassengerHomeContent({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    // print(state.currentReserve);
    return Stack(children: [
      Column(
        children: [
          _headerHome(context),
          Padding(
            padding: const EdgeInsets.only(
              top: 16, 
              bottom: 16, 
              left: 26, 
              right: 26
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Bienvenido nuevamente ${state.currentUser?.name}!',
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
                  'Encontrá tu próximo viaje...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A48B),
                  ),
                ),
                _tripCard(context),

                const SizedBox(height: 22),
                const Text(
                  'Reservas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A48B),
                  ),
                ),
                const SizedBox(height: 8),

                // if(state.currentReserve != null)
                //   ReservesItem(state.currentReserve, 'currentTrip')
                // else
                // _reserveCard(context),

                (state.reservesAll != null &&
                        state.reservesAll?.futureReservations != null &&
                        state.reservesAll!.futureReservations.isNotEmpty
                    ? ReservesItem(state.reservesAll?.futureReservations[0],
                        'futureReservations')
                    : _reserveCard(context)),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _headerHome(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
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

  Widget _tripCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              width: 160,
              margin: const EdgeInsets.only(top: 30, bottom: 15),
              child: Image.asset(
                'lib/assets/img/car_logo-fillout.png',
                fit: BoxFit.cover,
              )),
          ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, 'passenger/request/trips');
              context.go('/passenger/0/request/trips');
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              elevation: MaterialStateProperty.all<double>(0),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(
                  color: Color(0xFF00A98F),
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Buscar',
                  style: TextStyle(
                    color: Color(0xFF00A98F),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, color: Color(0xFF00A48B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reserveCard(BuildContext context) {
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
                  SizedBox(
                    width: 250,
                    child: Text(
                      'No tenes reservas registradas. Encontrá tu próximo viaje',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
