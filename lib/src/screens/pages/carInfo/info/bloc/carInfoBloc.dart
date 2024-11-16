import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/carInfoEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/carInfoState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarInfoBloc extends Bloc<CarInfoEvent, CarInfoState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;

  // Constructor
  CarInfoBloc(this.authUseCases, this.carInfoUseCases): super(CarInfoState()) {
    
    // Testing Car
    void _setTestCarInfo(GetCarInfo event, Emitter<CarInfoState> emit) {
      final CarInfo testCarInfo = CarInfo(
        idDriver: 1,
        brand: 'Ford',
        model: 'Mustang',
        patent: 'AA001AA',
        color: 'red',
        year: 2024,
        nroGreenCard: '12345678',
      );

      emit(state.copyWith(
        car: testCarInfo,
      ));
    }

    on<GetCarInfo>((event, emit) async {
      try {
        print('Entrando a GetCarInfo ----------------------------------------------------');
        // Debo pasarle el idVehicle para obtener el vehiculo
        Resource response = await carInfoUseCases.getCarInfo.run(event.idVehicle);
        
        if (response is Success) {
          final carInfo = response.data as CarInfo;
          emit(
            state.copyWith(
              car: carInfo
            )
          );
        } else {
          print('============================ Sin Respuesta - Uso TestCarInfo ============================');
          _setTestCarInfo(event, emit);
        }
      } catch (error) {
        print('============================ Falla el Try Catch - Uso TestCarInfo ============================');
        _setTestCarInfo(event, emit);
      }
    }); 
  }

}