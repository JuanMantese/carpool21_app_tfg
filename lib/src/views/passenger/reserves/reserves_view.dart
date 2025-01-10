// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_event.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_state.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/reserves_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservesView extends StatefulWidget {
  const ReservesView({super.key});

  @override
  State<ReservesView> createState() => _ReservesPageState();
}

class _ReservesPageState extends State<ReservesView> with AutomaticKeepAliveClientMixin {
  
  @override
  void initState() {
    super.initState();
    print('Entrando al Historial de Reservas');
    // Dispara el evento para obtener el historial de reservas usuario
    context.read<ReservesBloc>().add(GetReservesAll());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Le dice al view como fue construido originalmente el widget para preservarlo

    return Scaffold(
      body: BlocBuilder<ReservesBloc, ReservesState>(
        builder: (context, state) {
          final response = state.response;

          if (response is Loading) {
            return const Center(child: CircularProgressIndicator());
          } 

          // Estado de éxito
          else if (response is Success<ReservesAll>) {
            final reservesAll = response.data;

            // Mostrar un mensaje si no hay viajes disponibles
            if (reservesAll.futureReservations.isEmpty && reservesAll.pastReservations.isEmpty) {
              return const Center(
                child: Text(
                  'No hay reservas disponibles.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ReservesContent(state);
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