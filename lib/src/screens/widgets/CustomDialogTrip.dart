import 'package:carpool_21_app/src/screens/pages/driver/mapFinder/bloc/driverMapFinderBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapFinder/bloc/driverMapFinderEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomDialogTrip extends StatelessWidget {
  
  final BuildContext context;

  CustomDialogTrip({
    super.key,
    required this.context, 
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_rounded,
            size: 40,
            color: Color(0xFF006D59),
          ),
          SizedBox(height: 10),
          Text(
            'Elegí tu ruta!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      
      content: Text(
        'Elegí el lugar de Origen/Destino de tu viaje.'
      ),
      
      actions: <Widget>[
        ButtonBar(
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _setPredefinedLocation(
                  context,
                  // LatLng(-31.322187, -64.2219203), // Coordenadas del Campus Universitario
                  LatLng(-31.322187171680053, -64.22192009394531),
                  'Campus Siglo 21',
                  'Universidad Siglo 21, De los Latinos, Córdoba, Argentina',
                  'destination',
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Hacia Campus Universitaro',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            
            ElevatedButton(
              onPressed: () {
                _setPredefinedLocation(
                  context,
                  // LatLng(-31.4227129, -64.18551), // Coordenadas del Nva Cba 
                  LatLng(-31.422511271602012, -64.18393187764372,),
                  'Cede Nueva Córdoba',
                  'Universidad Siglo 21, Ituzaingó, Córdoba, Argentina',
                  'destination',
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Hacia Sede Nueva Córdoba',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                _setPredefinedLocation(
                  context,
                  // LatLng(-31.322187, -64.2219203), // Coordenadas del Campus Universitario
                  LatLng(-31.322187171680053, -64.22192009394531),
                  'Campus Siglo 21',
                  'Universidad Siglo 21, De los Latinos, Córdoba, Argentina',
                  'pickUp',
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Desde Campus Universitaro',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            
            ElevatedButton(
              onPressed: () {
                _setPredefinedLocation(
                  context,
                  // LatLng(-31.4227129, -64.18551), // Coordenadas del Campus Universitario
                  LatLng(-31.422511271602012, -64.18393187764372,),
                  'Cede Nueva Córdoba',
                  'Universidad Siglo 21, Ituzaingó, Córdoba, Argentina',
                  'pickUp',
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Desde Sede Nueva Córdoba',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A98F)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _setPredefinedLocation(BuildContext context, LatLng location, String neighborhood, String address, String locationType) {
    context.pop(); // Cerrar el modal
    context.push('/driver/0/finder');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverMapFinderBloc>().add(
        SelectPredefinedLocation(
          location: location,
          neighborhood: neighborhood,
          address: address,
          locationType: locationType
        )
      );
    });
  }
}