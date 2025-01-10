import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_state.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/trip_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<TripDetailBloc, TripDetailState>(
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
            return Container(
              child: const Text('Error interno en ReserveDetail')
            );
          }
        }
      ),
    );
  }
}