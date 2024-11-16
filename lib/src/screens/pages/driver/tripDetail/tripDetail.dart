import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/tripDetailState.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/tripDetailContent.dart';
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

  @override
  void initState() {
    super.initState();    

    context.read<TripDetailBloc>().add(TripDetailInitMap());

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los datos de Origen y Destino desde CreateTrip
      final args = widget.arguments;
      
      // final args = ModalRoute.of(context)!.settings.arguments as Map;

      idTrip = args['idDriverRequest'];

      context.read<TripDetailBloc>().add(GetTripDetail(idTrip: idTrip));

      // Introduce a delay before initializing the map and adding polyline
      Future.delayed(Duration(seconds: 2), () {
        // Ubicando marcadores e iniciando el mapa
        context.read<TripDetailBloc>().add(InitializeMap());
        // Aca se ejecuta la funcion para agregar la ruta en el mapa origen/destino y realizar el movimiento de la camara
        context.read<TripDetailBloc>().add(AddPolyline());
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<TripDetailBloc, TripDetailState>(
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
          if (state.tripDetail == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tripDetail != null) {
            return TripDetailContent(state.tripDetail, state);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}