
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/carInfoBloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/carInfoEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/carInfoState.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/carInfoContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarInfoPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const CarInfoPage({
    super.key,
    required this.arguments
  });

  @override
  State<CarInfoPage> createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage> {
  late int idVehicle;
  late String originPage = '';

  @override
  void initState() {
    super.initState();

     // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los argumentos del Vehiculo
      final args = widget.arguments;

      // final args = ModalRoute.of(context)!.settings.arguments as Map;
      
      idVehicle = args['idVehicle'];
      originPage = args['originPage'];

      // Dispara el evento para obtener la información del vehiculo
      context.read<CarInfoBloc>().add(GetCarInfo(idVehicle: idVehicle));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CarInfoBloc, CarInfoState>(
          builder: (context, state) {
            return CarInfoContent(state.car, originPage);
          },
        ),
      ),
    );
  }
}
