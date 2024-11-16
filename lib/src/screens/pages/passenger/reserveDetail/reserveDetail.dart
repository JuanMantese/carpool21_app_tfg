import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailBloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserveDetailState.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/reserveDetailContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveDetailPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const ReserveDetailPage({
    super.key,
    required this.arguments
  });

  @override
  State<ReserveDetailPage> createState() => _ReserveDetailPageState();
}

class _ReserveDetailPageState extends State<ReserveDetailPage> {
  
  late int idReserve;
  
  @override
  void initState() {
    super.initState();

    context.read<ReserveDetailBloc>().add(ReserveDetailInitMap());

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo el Id de la reserva
      final args = widget.arguments;
      
      // final args = ModalRoute.of(context)!.settings.arguments as Map;

      idReserve = args['idReserve'];

      context.read<ReserveDetailBloc>().add(GetReserveDetail(idReserve: idReserve));

      Future.delayed(Duration(seconds: 2), () {
        // Ubicando marcadores e iniciando el mapa
        context.read<ReserveDetailBloc>().add(InitializeMap());
        // Aca se ejecuta la funcion para agregar la ruta en el mapa origen/destino y realizar el movimiento de la camara
        context.read<ReserveDetailBloc>().add(AddPolyline());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ReserveDetailBloc, ReserveDetailState>(
        builder: (context, state) {
          final response = state.response;

           // if (response is Loading) {
          //   return const Center(child: CircularProgressIndicator());
          // } 
          // else if (response is Success) {
          //   return TripDetailContent(state);
          // } 
          // else {
          //   // return Container(
          //   //   child: Text('No logramos entrar a TripDetailContent')
          //   // );
          //   return TripDetailContent(state);
          // }
          if (state.reserveDetail == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ReserveDetailContent(state.reserveDetail, state);
          }
        }
      ),
    );
  }
}