// ignore_for_file: avoid_print
import 'dart:ui';
import 'package:carpool_21_app/src/domain/models/trip_status.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_state.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/trip_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class TripDetailPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const TripDetailPage({
    super.key,
    required this.arguments
  });

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {

  late int idTrip;
  late TripDetailBloc tripDetailBloc;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Referencia al Bloc del TripDetail
    tripDetailBloc = context.read<TripDetailBloc>();

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los datos de Origen y Destino desde CreateTrip
      final args = widget.arguments;

      idTrip = args['idDriverRequest'];

      context.read<TripDetailBloc>().add(GetTripDetail(idTrip: idTrip));
    });
  }

  @override
  void dispose() {
    // Usa la referencia guardada para ejecutar el evento ResetState
    tripDetailBloc.add(ResetState());
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
      backgroundColor: Colors.white,
      body: BlocListener<TripDetailBloc, TripDetailState>(
        listener: (context, state) {
          // Manejando la respuesta al iniciar viaje
          final resStartTrip = state.responseStartTrip;
          
          // Esperando la respuesta
          if (resStartTrip is Loading) {
            _setLoading(true);
          } else {
            _setLoading(false);
          }

          // Success Status
          if (resStartTrip is Success) {
            print('Viaje Iniciado Exitosamente >>>>>>>>>>>>>>>>>>>>>>>>>>>');
            print(resStartTrip.data);

            TripStatus tripStatusData = resStartTrip.data; 

            // Redireccionamiento a la pantalla de Viaje en Vivo
            context.push('/driver/0/mapTripDriver', extra: {
              'idTrip': tripStatusData.idTrip
            });

            Fluttertoast.showToast(msg: 'Viaje iniciado', toastLength: Toast.LENGTH_LONG);
          }

          // Error Status
          else if (resStartTrip is ErrorData) {
            Fluttertoast.showToast(
              msg: 'Error al iniciar el viaje: ${resStartTrip.message}',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: Stack(
          children: [
            BlocBuilder<TripDetailBloc, TripDetailState>(
              builder: (context, state) {
                final responseTripDetail = state.responseGetTripDetail;

                if (responseTripDetail is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } 

                // Success Status
                else if (responseTripDetail is Success) {
                  return TripDetailContent(
                    responseTripDetail.data, 
                    state
                  );
                } 

                // Error Status
                else if (responseTripDetail is ErrorData) {
                  Future.microtask(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(responseTripDetail.message)),
                    );
                    Navigator.of(context).pop(); // Redirige al Home
                  });

                  return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
                }  
                
                else {
                  return const Center(
                    child: Text('Error interno en ReserveDetail')
                  );
                }
              }
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
        )
      )
    );
  }
}