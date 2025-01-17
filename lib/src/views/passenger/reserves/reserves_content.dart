// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_state.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/reserves_item.dart';
import 'package:flutter/material.dart';

class ReservesContent extends StatelessWidget {
  final ReservesState state;

  const ReservesContent(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    // print(state.testingReservesAll?.currentReserve);

    return Scaffold(
      body: Stack(
        children: [
          // Permite listar los reservas de un Pasajero - CurrentReserve, FutureReserves, HistoricalReserves
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 170, bottom: 40),
              child: Column(
                children: [
                  // Future Reservations
                  if (state.reservesAll!.futureReservations.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Proximos Viajes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF006D59),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Color(0xFF006D59),
                            thickness: 2,
                          ),
                        ),
                        ...state.reservesAll!.futureReservations.map((reserve) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReservesItem(reserve, 'futureTrips'),
                          );
                        }),
                      ],
                    ),

                  // Historical Reservations
                  if (state.reservesAll!.pastReservations.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Reservas Historicas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF006D59),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Color(0xFF006D59),
                            thickness: 2,
                          ),
                        ),
                        ...state.reservesAll!.pastReservations
                            .map((reserve) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child:
                                ReservesItem(reserve, 'historicalTrips'),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Header de Reservas
          _headerTripsAvailable(context),

          // Decoration
          const Positioned(
            top: 108,
            right: 108,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 66,
            right: 90,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 100,
            right: 76,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 76,
            right: 56,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
        ],
      )
    );
  }

  Widget _headerTripsAvailable(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
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
          top: MediaQuery.of(context).padding.top + 20,
          bottom: 20,
          right: 15,
          left: 15,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'lib/assets/img/logo-carpool21-white.png',
                height: 80,
                width: 60,
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'MIS RESERVAS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
