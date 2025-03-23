
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TripsItem extends StatelessWidget {
  
  final TripDetail? tripDetail;
  final String tripType;

  const TripsItem(
    this.tripDetail, 
    this.tripType, 
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int? idTrip = tripDetail?.idTrip;

        // Si el viaje esta INCOURSE, se lleva al screen MapTripDriver
        if (tripDetail?.state == 3) {
          context.push('/driver/0/mapTripDriver', extra: {
            'idTrip': idTrip
          });
        } else {
          context.push('/driver/0/trip/detail', extra: {
            'idDriverRequest': idTrip,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: _gradient(tripType),
          // LinearGradient(
          //   colors: [
          //     const Color(0xFF009C84).withOpacity(0.88),
          //     const Color.fromARGB(255, 0, 139, 118),
          //     const Color(0xFF009C84).withOpacity(1),
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.my_location, color: Colors.white),
                      title: Text(
                        tripDetail!.pickupNeighborhood,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        tripDetail!.pickupText,
                        maxLines: 3, // Máximo de 3 líneas
                        overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es muy largo
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        tripDetail!.destinationNeighborhood,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        tripDetail!.destinationText,
                        maxLines: 3, // Máximo de 3 líneas
                        overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es muy largo
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 8.0),
                    //   child: Text(
                    //     // 'con ${reserveDetail.car.brand} ${reserveDetail.car.model}',
                    //     'Juan',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    _startTripHour(tripDetail!.departureTime),
                    const SizedBox(height: 10),
                    
                    // if (tripType != 'historicalTrips') 
                    //   _chatButton(),

                    // _startButton(context),
                    const SizedBox(height: 6),

                    if (tripType == 'futureTrips') 
                      _cancelButton(),
                      
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _gradient(String tripType) {
    if(tripType == 'currentTrip') {
      return LinearGradient(
        colors: [
          const Color.fromARGB(255, 2, 92, 79).withOpacity(0.88),
          const Color.fromARGB(255, 0, 139, 118),
          const Color.fromARGB(255, 2, 92, 79).withOpacity(1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (tripType == 'futureTrips') {
      return LinearGradient(
        colors: [
          const Color(0xFF009C84).withOpacity(0.88),
          const Color.fromARGB(255, 0, 139, 118),
          const Color(0xFF009C84).withOpacity(1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return LinearGradient(
        colors: [
          const Color(0xFF7C8180).withOpacity(0.88),
          const Color(0xFF7C8180).withOpacity(1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  Widget _startTripHour(String departureTime) {
    final formattedTime = DateFormat.Hm().format(DateTime.parse(departureTime));
    return Container(
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(38, 51, 43, 0.1), // Top color
            Color.fromRGBO(38, 51, 43, 0.43),
            Color.fromRGBO(38, 51, 43, 0.15),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Text(
            formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          const Text(
            'Horario',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ]
      ),
    );
  }

  Widget _startButton(BuildContext context) {
    return Container(
      width: 190,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(0, 117, 255, 0.66), // Top color
            Color.fromRGBO(0, 163, 255, 0.43), // Top color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<TripDetailBloc>().add(ChangeTripStatus(idTrip: tripDetail!.idTrip));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, 
          padding: const EdgeInsets.symmetric(
            horizontal: 1.0,
            vertical: 1.0,
          ),
          minimumSize: const Size(double.infinity, 20), // width and heigh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Iniciar Viaje',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _chatButton() {
    return Container(
      width: 190,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(0, 117, 255, 0.66), // Top color
            Color.fromRGBO(0, 163, 255, 0.43), // Top color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          // onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, 
          padding: const EdgeInsets.symmetric(
            horizontal: 1.0,
            vertical: 1.0,
          ),
          minimumSize: const Size(double.infinity, 20), // width and heigh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Chatear',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return Container(
      width: 190,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 0, 0, 0.66), // Top color
            Color.fromRGBO(255, 0, 0, 0.43), // Top color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          // onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, 
          padding: const EdgeInsets.symmetric(
            horizontal: 1.0,
            vertical: 1.0,
          ),
          minimumSize: const Size(double.infinity, 20), // width and heigh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Cancelar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

}