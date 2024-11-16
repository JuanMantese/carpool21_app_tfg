import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/DriverMapBookingInfoContent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapBookingInfo extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const DriverMapBookingInfo({
    super.key,
    required this.arguments
  });

  @override
  State<DriverMapBookingInfo> createState() => _DriverMapBookingInfoState();
}

class _DriverMapBookingInfoState extends State<DriverMapBookingInfo> {
  // Inicializando variables
  String? pickUpNeighborhood;
  String? pickUpText;
  LatLng? pickUpLatLng;
  String? destinationNeighborhood;
  String? destinationText;
  LatLng? destinationLatLng;
  String? departureTime;

  @override
  void initState() {
    super.initState();
    
    // Iniciando el Controller del Mapa cuando entro a la pantalla 
    context.read<DriverMapBookingInfoBloc>().add(DriverMapBookingInfoInitMap());

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los datos de Origen y Destino desde DriverMapFinder
      final arguments = widget.arguments;

      // Recibiendo los datos de Origen y Destino desde DriverMapFinder
      // Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      // Seteando valores
      pickUpNeighborhood = arguments['pickUpNeighborhood'];
      pickUpText = arguments['pickUpText'];
      pickUpLatLng = arguments['pickUpLatLng'];
      destinationNeighborhood = arguments['destinationNeighborhood'];
      destinationText = arguments['destinationText'];
      destinationLatLng = arguments['destinationLatLng'];
      departureTime = arguments['departureTime'];
      print('pickUpNeighborhood: ${pickUpNeighborhood}');
      print('pickUpText: ${pickUpText}');
      print('pickUpLatLng: ${pickUpLatLng}');
      print('destinationNeighborhood: ${destinationNeighborhood}');
      print('destinationText: ${destinationText}');
      print('destinationLatLng: ${destinationLatLng}');
      print('departureTime: ${departureTime}');
      

      context
        .read<DriverMapBookingInfoBloc>()
        .add(DriverMapBookingInfoInitEvent(
          pickUpNeighborhood: pickUpNeighborhood!,
          pickUpLatLng: pickUpLatLng!,
          destinationNeighborhood: destinationNeighborhood!,
          pickUpText: pickUpText!,
          destinationLatLng: destinationLatLng!,
          destinationText: destinationText!,
          departureTime: departureTime!
        ));
      
      // Aca se ejecuta la funcion para agregar la ruta en el mapa origen/destino
      context.read<DriverMapBookingInfoBloc>().add(AddPolyline());
 
      // Ubicamos la camara sobre la ruta marcada
      context.read<DriverMapBookingInfoBloc>().add(ChangeMapCameraPosition(
        pickUpLatLng: pickUpLatLng!,
        destinationLatLng: destinationLatLng!
      ));

      // Trayendo los datos: Tiempo estimado del trayecto y Distancia del punto de origen al punto de destino
      context.read<DriverMapBookingInfoBloc>().add(GetTimeAndDistanceValues());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriverMapBookingInfoBloc, DriverMapBookingInfoState>(
        builder: (context, state) {
          final responseTimeAndDistance = state.responseTimeAndDistance;

          // if (responseTimeAndDistance is Loading) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          // else if (responseTimeAndDistance is Success) {
          //   TimeAndDistanceValues timeAndDistanceValues = responseTimeAndDistance.data as TimeAndDistanceValues;
          //   return Scaffold(
          //     body: DriverMapBookingInfoContent(state, timeAndDistanceValues)
          //   );
          // }

          // Verifica si el Controller del Map se inicializo completamente antes de entrar
          if (state.controller == null) {
            return Center(child: CircularProgressIndicator());
          }

          // DELETE - Eliminar: Esta puesto para probar sin el back
          TimeAndDistanceValues mockTimeAndDistanceValues = TimeAndDistanceValues(
            tripPrice: 1000.0,
            distance: Distance(text: "15 km", value: 10.0),
            duration: Duration(text: "30 minutos", value: 15.0),
          );
          return Scaffold(
              body: DriverMapBookingInfoContent(
                state, 
                mockTimeAndDistanceValues
              )
            );
          // DELETE - Eliminar: Esta puesto para probar sin el back
           
          // DESCOMENTAR
          // return Container(); 
        },
      ),
    );
  }
}
