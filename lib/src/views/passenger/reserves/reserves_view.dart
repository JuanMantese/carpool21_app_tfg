// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_event.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_state.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/reserves_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
            return ReservesContent(state);
          }

          else if (response is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              showOverlayMessage(
                context, 
                response.message,
                customTitle: 'Error al obtener las reservas',
                type: AlertType.error
              );
              context.go('/passenger/0'); // Redirije al home del passenger
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
          }

          else {
            return const Center(
              child: Text('Error interno en ReservesView')
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}