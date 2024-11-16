import 'package:carpool_21_app/src/screens/pages/driver/trips/bloc/tripsBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/trips/bloc/tripsEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/trips/bloc/tripsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {

  @override
  void initState() {
    super.initState();
    
    // Dispara el evento para obtener la información del usuario
    context.read<TripsBloc>().add(GetTripsAll());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          if (state.testingTripsAll == null) {
            // Mostrar un indicador de carga mientras se obtiene la información del usuario
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(child: Text('Aqui'),);
            // ReservesContent(state);
          }
          // return pageList[state.pageIndex];
        },
      ),
    );
  }
}