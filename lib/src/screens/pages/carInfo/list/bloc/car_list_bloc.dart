// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarListBloc extends Bloc<CarListEvent, CarListState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;

  // Constructor
  CarListBloc(
    this.authUseCases, 
    this.carInfoUseCases
  ): super(
    CarListState(
      response: Loading()
    )
  ) {
    
    // Array Test of Car List
    // List<CarInfo> toCarsList = [
    //   CarInfo(
    //     idDriver: 1,
    //     brand: 'Ford',
    //     model: 'Mustang',
    //     patent: 'AA001AA',
    //     color: 'red',
    //     year: 2022,
    //     nroGreenCard: '12345678',
    //   ),
    //   CarInfo(
    //     idDriver: 1,
    //     brand: 'Jeep',
    //     model: 'Compass',
    //     patent: 'AA002AA',
    //     color: 'red',
    //     year: 2023,
    //     nroGreenCard: '12345678',
    //   ),
    //   CarInfo(
    //     idDriver: 1,
    //     brand: 'Ford',
    //     model: 'F-150 Raptor',
    //     patent: 'AA003AA',
    //     color: 'red',
    //     year: 2024,
    //     nroGreenCard: '12345678',
    //   ),
    //   CarInfo(
    //     idDriver: 1,
    //     brand: 'Ford',
    //     model: 'F-150 Raptor',
    //     patent: 'AA003AA',
    //     color: 'red',
    //     year: 2024,
    //     nroGreenCard: '12345678',
    //   ),
    //   CarInfo(
    //     idDriver: 1,
    //     brand: 'Ford',
    //     model: 'F-150 Raptor',
    //     patent: 'AA003AA',
    //     color: 'red',
    //     year: 2024,
    //     nroGreenCard: '12345678',
    //   ),
    // ];

    on<GetCarList>((event, emit) async {
      print('GetCarList ---------------------');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el listado de vehiculos
      Resource<List<CarInfo>> carListRes = await carInfoUseCases.getCarList.run();

      emit(
        state.copyWith(
          response: carListRes,
        )
      );
    }); 
  }

}