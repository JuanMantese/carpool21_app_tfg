
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_state.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/car_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  @override
  void initState() {
    super.initState();
    // Dispara el evento para obtener la información de todos los vehiculos del conductor
    context.read<CarListBloc>().add(GetCarList());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CarListBloc, CarListState>(
          builder: (context, state) {
            final carListRes = state.response;

            if (carListRes is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            else if (carListRes is Success) {
              List<CarInfo> carList = carListRes.data as List<CarInfo>;
              
              return CarListContent(state, carList);
            } 

            else if (carListRes is ErrorData) {
              // Muestra un mensaje y redirige al Home
              Future.microtask(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(carListRes.message)),
                );
                Navigator.of(context).pop(); // Redirige al Home
              });

              return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
            }

            else {
              return Container(
                child: const Text('Error interno en CarList')
              );
            }
          },
        ),
      ),
    );
  }
}