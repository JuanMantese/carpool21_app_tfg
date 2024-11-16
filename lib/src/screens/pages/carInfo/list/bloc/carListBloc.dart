
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarListBloc extends Bloc<CarListEvent, CarListState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;

  // Constructor
  CarListBloc(
    this.authUseCases, 
    this.carInfoUseCases
  ): super(CarListState()) {
    
    // DELETE - Testeando con un objeto de prueba
    void _setTestCarList(GetCarList event, Emitter<CarListState> emit) {
      List<CarInfo> toCarsList = [
        CarInfo(
          idDriver: 1,
          brand: 'Ford',
          model: 'Mustang',
          patent: 'AA001AA',
          color: 'red',
          year: 2022,
          nroGreenCard: '12345678',
        ),
        CarInfo(
          idDriver: 1,
          brand: 'Jeep',
          model: 'Compass',
          patent: 'AA002AA',
          color: 'red',
          year: 2023,
          nroGreenCard: '12345678',
        ),
        CarInfo(
          idDriver: 1,
          brand: 'Ford',
          model: 'F-150 Raptor',
          patent: 'AA003AA',
          color: 'red',
          year: 2024,
          nroGreenCard: '12345678',
        ),
        CarInfo(
          idDriver: 1,
          brand: 'Ford',
          model: 'F-150 Raptor',
          patent: 'AA003AA',
          color: 'red',
          year: 2024,
          nroGreenCard: '12345678',
        ),
        CarInfo(
          idDriver: 1,
          brand: 'Ford',
          model: 'F-150 Raptor',
          patent: 'AA003AA',
          color: 'red',
          year: 2024,
          nroGreenCard: '12345678',
        ),
      ];

      emit(state.copyWith(
        testingArrayCars: toCarsList,
      ));
    }

    on<GetCarList>((event, emit) async {
      print('GetCarList');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );
      // Recuperando los vehiculos del Driver
      Resource<List<CarInfo>> response = await carInfoUseCases.getCarList.run();
      print('Response - $response');
      emit(
        state.copyWith(
          response: response,
        )
      );

      // DELETE - Testeando con un objeto de prueba
      // print('Usando el Array de prueba');
      // _setTestCarList(event, emit);
    }); 
  }

}