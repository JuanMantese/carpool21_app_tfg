// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/bloc/map_trip_passenger_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/mapTripPassenger/map_trip_passenger_content.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/passengerRatingTrip/passenger_rating_trip.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MapTripPassengerPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const MapTripPassengerPage({super.key, required this.arguments});

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
      context.read<MapTripPassengerBloc>().add(GetMapReserveDetail(idReserve: idReserve));

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
      body: BlocListener<MapTripPassengerBloc, MapTripPassengerState>(
        listener: (context, state) {
          if (state.tripFinished) {
            final resReserveDetail = state.responseGetReserveDetail;
            
            if (resReserveDetail is Success) {
              print('Viaje Finalizado Exitosamente >>>>>>>>>>>>>>>>>>>>>>>>>>>');
              ReserveDetail reserveDetail = resReserveDetail.data as ReserveDetail; 

              // Saliendo del Viaje y Calificando a los Pasajeros
              Navigator.of(context).pop();
              DialogPassengerRatingTrip(
                context: context,
                tripReservationDetail: reserveDetail,
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, 
                  'Gracias por viajar con nosotros',
                  customTitle: 'Viaje finalizado exitosamente',
                  type: AlertType.success
                );
              });

              // Fluttertoast.showToast(msg: 'Viaje finalizado', toastLength: Toast.LENGTH_LONG);
            }
          }
        },
        child: BlocBuilder<MapTripPassengerBloc, MapTripPassengerState>(
          builder: (context, state) {
            final resReserveDetail = state.responseGetReserveDetail;

            if (resReserveDetail is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Success Status
            else if (resReserveDetail is Success) {
              // Verifica si el Controller del Map se inicializo completamente antes de entrar
              if (state.controller == null) {
                return const Center(child: CircularProgressIndicator());
              }

              ReserveDetail reserveDetail = resReserveDetail.data as ReserveDetail;

              return Scaffold(
                body: MapTripPassengerContent(state, reserveDetail)
              );
            }

            // Error Status
            else if (resReserveDetail is ErrorData) {
              Future.microtask(() {
                showOverlayMessage(
                  context, 
                  resReserveDetail.message,
                  customTitle: 'Viaje en vivo no disponible',
                  type: AlertType.error
                );
                context.pop(); // Redirige al Home
              });

              return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
            } else {
              return const Center(
                child: Text('Error interno en MapTripPassenger')
              );
            }
          },
        ),
      ),
    );
  }
}
