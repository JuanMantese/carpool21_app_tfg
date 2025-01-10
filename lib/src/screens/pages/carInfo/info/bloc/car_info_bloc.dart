// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarInfoBloc extends Bloc<CarInfoEvent, CarInfoState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;

  // Constructor
  CarInfoBloc(
    this.authUseCases, 
    this.carInfoUseCases
  ): super(
    CarInfoState(
      response: Loading(), 
    )
  ) {
    
    // Testing Car
    // final CarInfo testCarInfo = CarInfo(
    //   idDriver: 1,
    //   brand: 'Ford',
    //   model: 'Mustang',
    //   patent: 'AA001AA',
    //   color: 'red',
    //   year: 2024,
    //   nroGreenCard: '12345678',
    // );
    

    on<GetCarInfo>((event, emit) async {
      print('GetCarInfo ---------------------');

      // Debo pasarle el idVehicle para obtener el vehiculo
      Resource<CarInfo> carInfoRes = await carInfoUseCases.getCarInfo.run(event.idVehicle);
      
      emit(
        state.copyWith(
          response: carInfoRes
        )
      );
    }); 

  }
}