
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_state.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/car_info_content.dart';
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
      body: BlocBuilder<CarInfoBloc, CarInfoState>(
        builder: (context, state) {
          final carInfoRes = state.response;

          if (carInfoRes is Loading) {
            return const Center(child: CircularProgressIndicator());
          } 

          // Estado de éxito
          else if (carInfoRes is Success<CarInfo>) {
            final carInfoData = carInfoRes.data;

            return CarInfoContent(carInfoData, originPage);
          }

          else if (carInfoRes is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(carInfoRes.message)),
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
}
