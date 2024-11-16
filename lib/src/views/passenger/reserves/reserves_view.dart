import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reservesBloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reservesEvent.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reservesState.dart';
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
    
    // Dispara el evento para obtener la información del usuario
    context.read<ReservesBloc>().add(GetReservesAll());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Le dice al view como fue construido originalmente el widget para preservarlo

    return Scaffold(
      body: BlocBuilder<ReservesBloc, ReservesState>(
        builder: (context, state) {
          if (state.testingReservesAll == null) {
            // Mostrar un indicador de carga mientras se obtiene la información del usuario
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // return Container(child: Text('Aqui'),);
            return const ReservesContent();
          }
          // return pageList[state.pageIndex];
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}