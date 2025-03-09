// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/map_trip_passenger_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapTripPassengerPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const MapTripPassengerPage({
    super.key,
    required this.arguments
  });

  @override
  State<MapTripPassengerPage> createState() => _MapTripPassengerState();
}

class _MapTripPassengerState extends State<MapTripPassengerPage> {

  // Inicializando variables
  late int idReserve;
  late MapTripPassengerBloc mapTripPassengerBloc;

  @override
  void initState() {
    super.initState();

    // Referencia al Bloc del MapTripPassengerBloc
    mapTripPassengerBloc = context.read<MapTripPassengerBloc>();
    
    // Iniciando el Controller del Mapa cuando entro a la pantalla 
    // context.read<DriverMapBookingInfoBloc>().add(DriverMapBookingInfoInitMap());

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    
      // Recibiendo el Id de la reserva
      final args = widget.arguments;
      idReserve = args['idReserve'];

      // Inicializando la pantalla con el Mapa y recuperando la información
      context.read<MapTripPassengerBloc>().add(MapTripPassangerInitMap());
      context.read<MapTripPassengerBloc>().add(GetMapReserveDetail(idReserve: idReserve));
      context.read<MapTripPassengerBloc>().add(ListenDriverPositionSocketIO());

      
      // Aca se ejecuta la funcion para agregar la ruta en el mapa origen/destino
      // context.read<DriverMapBookingInfoBloc>().add(AddPolyline());
 
      // Ubicamos la camara sobre la ruta marcada
      // context.read<DriverMapBookingInfoBloc>().add(ChangeMapCameraPosition(
      //   pickUpLatLng: pickUpLatLng!,
      //   destinationLatLng: destinationLatLng!
      // ));

      // Trayendo los datos: Tiempo estimado del trayecto y Distancia del punto de origen al punto de destino
      // context.read<DriverMapBookingInfoBloc>().add(GetTimeAndDistanceValues());
    });
  }

  @override
  void dispose() {
    // Usa la referencia guardada para ejecutar el evento ResetState
    mapTripPassengerBloc.add(ResetState());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapTripPassengerBloc, MapTripPassengerState>(
        builder: (context, state) {
          final resReserveDetail = state.responseGetReserveDetail;

          // Verifica si el Controller del Map se inicializo completamente antes de entrar
          if (state.controller == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resReserveDetail is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Success Status
          else if (resReserveDetail is Success) {
            ReserveDetail reserveDetail = resReserveDetail.data as ReserveDetail;

            context.read<MapTripPassengerBloc>().add(AddMarkerPickup(
              lat: reserveDetail.tripRequest.pickupLat, 
              lng: reserveDetail.tripRequest.pickupLng
            ));

            context.read<MapTripPassengerBloc>().add(AddMarkerDestination(
              lat: reserveDetail.tripRequest.destinationLat, 
              lng: reserveDetail.tripRequest.destinationLng
            ));

            return Scaffold(
              body: MapTripPassengerContent(
                state,
                reserveDetail
              )
            );
          }

          // Error Status
          else if (resReserveDetail is ErrorData) {
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(resReserveDetail.message)),
              );
              Navigator.of(context).pop(); // Redirige al Home
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
          }  
          
          else {
            return Container(
              child: const Text('Error interno en ReserveDetail')
            );
          }
        },
      ),
    );
  }
}
