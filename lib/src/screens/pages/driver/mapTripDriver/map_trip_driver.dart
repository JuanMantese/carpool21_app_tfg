// ignore_for_file: avoid_print
import 'dart:ui';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_state.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/map_trip_driver_content.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTripDriverPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const MapTripDriverPage({super.key, required this.arguments});

  @override
  State<MapTripDriverPage> createState() => _MapTripDriverState();
}

class _MapTripDriverState extends State<MapTripDriverPage> {
  late int idTrip;
  late MapTripDriverBloc mapTripDriverBloc;

  bool _isLoading = false;
  bool _hasFinalizedTrip = false;

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

    // Referencia al Bloc del MapTripDriverBloc
    mapTripDriverBloc = context.read<MapTripDriverBloc>();

    // Iniciando el Controller del Mapa cuando entro a la pantalla
    // context.read<DriverMapBookingInfoBloc>().add(DriverMapBookingInfoInitMap());

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo el Id del viaje
      final args = widget.arguments;
      idTrip = args['idTrip'];

      print('Entramos a MapTripDriver -----------------------------------');

      // Inicializando la pantalla con el Mapa y recuperando la información
      context.read<MapTripDriverBloc>().add(MapTripDriverInitMap());
      context.read<MapTripDriverBloc>().add(GetMapTripDetail(idTrip: idTrip));

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
    mapTripDriverBloc.add(ResetState());
    super.dispose();
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapTripDriverBloc, MapTripDriverState>(
        listener: (context, state) {
          // Manejando la respuesta al finalizar el viaje
          final resEndTrip = state.responseEndTrip;
          
          // Esperando la respuesta
          if (resEndTrip is Loading) {
            _setLoading(true);
          } else {
            _setLoading(false);
          }

          // Success Status
          if (!_hasFinalizedTrip && resEndTrip is Success) {
            final resTripDetail = state.responseGetTripDetail;
  
            if (resTripDetail is Success) {
              print('Viaje Finalizado Exitosamente >>>>>>>>>>>>>>>>>>>>>>>>>>>');
              TripDetail tripDetail = resTripDetail.data as TripDetail; 

              // Emitiendo finalización del viaje a los pasajeros
              context.read<MapTripDriverBloc>().add(ChangeTripStatus(idTrip: tripDetail.idTrip));

              context.read<MapTripDriverBloc>().add(EmitUpdateStatusTripSocketIO());

              context.read<MapTripDriverBloc>().add(SetTripFinished(tripFinished: true));

              // Saliendo del Viaje y Calificando a los Pasajeros
              context.go('/driver/0');

              showOverlayMessage(
                context, 
                'Gracias por viajar con nosotros',
                customTitle: 'Viaje finalizado exitosamente',
                type: AlertType.success
              );
            
              // Actualizamos el flag para indicar que el viaje ya fue finalizado
              setState(() {
                _hasFinalizedTrip = true;
              });
            }
          }

          // Error Status
          else if (resEndTrip is ErrorData) {
            showOverlayMessage(
              context, 
              resEndTrip.message,
              customTitle: 'Error al finalizar el viaje',
              type: AlertType.error
            );
          }
        },
        child: Stack(
          children: [
            BlocBuilder<MapTripDriverBloc, MapTripDriverState>(
              builder: (context, state) {
                final resTripDetail = state.responseGetTripDetail;
            
                if (resTripDetail is Loading) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                // Success Status
                else if (resTripDetail is Success) {
                  // Verifica si el Controller del Map se inicializo completamente antes de entrar
                  if (state.controller == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  TripDetail tripDetail = resTripDetail.data as TripDetail;
            
                  return Scaffold(
                    body: MapTripDriverContent(state, tripDetail)
                  );
                }
            
                // Error Status
                else if (resTripDetail is ErrorData) {
                  Future.microtask(() {
                    showOverlayMessage(
                      context, 
                      resTripDetail.message,
                      customTitle: 'Viaje en vivo no disponible',
                      type: AlertType.error
                    );
                    context.pop(); // Redirige al Home
                  });
            
                  return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
                } else {
                  return const Center(child: Text('Error interno en ReserveDetail'));
                }
              },
            ),

             // CircularProgressIndicator visible cuando _isLoading sea true esperando la creación del viaje
            if (_isLoading) 
              Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0), // Desenfoque
                    child: Container(
                      color: Colors.black.withOpacity(0.3), // Fondo semi-transparente
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
