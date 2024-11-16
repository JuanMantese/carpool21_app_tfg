
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableState.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripsAvailableItem extends StatelessWidget {
  
  TripsAvailableState state;
  TripDetail? passengerRequest;

  TripsAvailableItem(this.state, this.passengerRequest, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        LatLng pickUpLatLng = LatLng(passengerRequest!.pickupLat, passengerRequest!.pickupLng);
        LatLng destinationLatLng = LatLng(passengerRequest!.destinationLat, passengerRequest!.destinationLng);

        // Navigator.pushNamed(context, '/passenger/request/trips/detail', arguments: {
        //   'idTrip': passengerRequest?.idTrip,
        //   'pickUpLatLng': pickUpLatLng,
        //   'pickUpText': passengerRequest!.pickupText,
        //   'destinationLatLng': destinationLatLng,
        //   'destinationText': passengerRequest!.destinationText,
        //   'departureTime': passengerRequest!.departureTime,
        //   'compensation': passengerRequest!.compensation,
        //   'driver': passengerRequest!.driver
        // });

        context.go('/passenger/0/request/trips/detail', extra: {
          'idTrip': passengerRequest?.idTrip,
          'pickUpLatLng': pickUpLatLng,
          'pickUpText': passengerRequest!.pickupText,
          'destinationLatLng': destinationLatLng,
          'destinationText': passengerRequest!.destinationText,
          'departureTime': passengerRequest!.departureTime,
          'compensation': passengerRequest!.compensation,
          'driver': passengerRequest!.driver
        });

        
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF009C84).withOpacity(0.88),
              const Color(0xFF009C84),
              const Color(0xFF009C84).withOpacity(0.88),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.my_location, color: Colors.white),
                      title: Text(
                        passengerRequest!.pickupNeighborhood ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(passengerRequest!.pickupText ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        passengerRequest!.destinationNeighborhood ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(passengerRequest!.destinationText ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 8.0),
                    //   child: Text(
                    //     // 'con ${passengerRequest.car.brand} ${passengerRequest.car.model}',
                    //     'Juan',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _startTripHour(passengerRequest!.departureTime),
                    const SizedBox(height: 10),
                    _availableSeats(passengerRequest!.availableSeats!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _availableSeats(int availableSeats) {
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
        children:[
          Text(
            '$availableSeats',
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),  
          const Text(
            'Lugares',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ] 
      ),
    );
  }
}