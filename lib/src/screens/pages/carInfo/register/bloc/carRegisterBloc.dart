
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/userUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/carRegisterEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/carRegisterState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarRegisterBloc extends Bloc<CarRegisterEvent, CarRegisterState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  UserUseCases userUseCases;
  final formKey = GlobalKey<FormState>();

  // Constructor
  CarRegisterBloc(
    this.authUseCases,
    this.carInfoUseCases,
    this.userUseCases,
  ): super(CarRegisterState()) {
    
    // We initialize the form with the values ​​of the current User
    on<CarRegisterInitEvent>((event, emit) {
      emit(state.copyWith(formKey: formKey));
    });

    on<BrandChanged>((event, emit) {
      emit(
        state.copyWith(
          brand: BlocFormItem(
            value: event.brandInput.value,
            error: event.brandInput.value.isEmpty ? 'Ingresá la Marca' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ModelChanged>((event, emit) {
      emit(
        state.copyWith(
          model: BlocFormItem(
            value: event.modelInput.value,
            error: event.modelInput.value.isEmpty ? 'Ingresá el Modelo' : null
          ),
          formKey: formKey
        )
      );
    });

    on<PatentChanged>((event, emit) {
      emit(
        state.copyWith(
          patent: BlocFormItem(
            value: event.patentInput.value,
            error: event.patentInput.value.isEmpty ? 'Ingresá la patente' : null
          ),
          formKey: formKey
        )
      );
    });

    on<YearChanged>((event, emit) {
      emit(
        state.copyWith(
          year: BlocFormItem(
            value: event.yearInput.value,
            error: event.yearInput.value.isEmpty ? 'Ingresá el año de tu Vehículo' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ColorChanged>((event, emit) {
      emit(
        state.copyWith(
          color: BlocFormItem(
            value: event.colorInput.value,
            error: event.colorInput.value.isEmpty ? 'Elegí el color' : null
          ),
          formKey: formKey
        )
      );
    });

    on<NroGreenCardChanged>((event, emit) {
      emit(
        state.copyWith(
          nroGreenCard: BlocFormItem(
            value: event.nroGreenCardInput.value,
            error: event.nroGreenCardInput.value.isEmpty ? 'Ingresá la Cedula Verde' : null
          ),
          formKey: formKey
        )
      );
    });

    on<FormSubmit>((event, emit) async {
      print('Marca: ${ state.brand.value }');
      print('Modelo: ${ state.model.value }');
      print('Patente: ${ state.patent.value }');
      print('Año del Vehículo: ${ state.year.value }');
      print('Color: ${ state.color.value }');      
      print('Cedula Verde: ${ state.nroGreenCard.value }');

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          response: Loading(),
          formKey: formKey
        )
      );

      // PARA QUE APAREZCA El estado de Loading (circle) - Tirar el Back y que quede cargando - ELIMINAR
      Resource response = await carInfoUseCases.createCarInfo.run(
        CarInfo(
          // idDriver: state.idDriver,
          brand: state.brand.value, 
          model: state.model.value, 
          patent: state.patent.value,
          year: int.parse(state.year.value),
          nroGreenCard: state.nroGreenCard.value,
          color: state.color.value
        )
      );

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          response: response,
          formKey: formKey
        )
      );
    });

    on<UpdateUserSession>((event, emit) async {
      Success<User> userDetailRes = await userUseCases.getUserDetailUseCase.run();
      print('Succes User Res: $userDetailRes');
      
      if (userDetailRes is Success) {
        User userDetail = userDetailRes.data;
        await authUseCases.updateUserSession.run(userDetail);
      }
    });
  }
}