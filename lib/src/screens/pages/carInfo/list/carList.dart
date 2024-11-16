
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListBloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListState.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/carListContent.dart';
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
            final response = state.response;
            print('Aqui $response');
            if (response is Loading) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (response is Success) {
              List<CarInfo> carList = response.data as List<CarInfo>;
              return CarListContent(state, carList);
            } 
            else {
              return Container(
                child: Text('No logramos entrar')
              );
            }

            // DELETE - Utilizamos un Array de prueba
            // if (state.testingArrayCars != null) {           
            //   return CarListContent(state, null);
            // } 
          },
        ),
      ),
    );
  }
}