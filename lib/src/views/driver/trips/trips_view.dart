// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_bloc.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_event.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_state.dart';
import 'package:carpool_21_app/src/views/driver/trips/trips_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    print('Entrando al Historial de Viajes');
    // Dispara el evento para obtener el historial de viajes del usuario
    context.read<TripsBloc>().add(GetTripsAll());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Le dice al view como fue construido originalmente el widget para preservarlo

    return Scaffold(
      body: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          final response = state.response;

          if (response is Loading) {
            return const Center(child: CircularProgressIndicator());
          } 

          // Estado de éxito
          else if (response is Success<TripsAll>) {
            final tripsAll = response.data;

            // Mostrar un mensaje si no hay viajes disponibles
            if (tripsAll.futureTrips.isEmpty && tripsAll.pastTrips.isEmpty) {
              return const Center(
                child: Text(
                  'No hay viajes disponibles.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return TripsContent(state);
          }

          else if (response is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.message)),
              );
              Navigator.of(context).pop(); // Redirige al Home
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
          }

          else {
            return Container(
              child: const Text('Error interno en TripsAvailable')
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}