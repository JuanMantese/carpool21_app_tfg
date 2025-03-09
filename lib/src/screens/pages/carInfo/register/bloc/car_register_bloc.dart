// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/user_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_state.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarRegisterBloc extends Bloc<CarRegisterEvent, CarRegisterState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  UserUseCases userUseCases;
  final formKey = GlobalKey<FormState>();
  final formKeyInsurance = GlobalKey<FormState>();

  // Constructor
  CarRegisterBloc(
    this.authUseCases,
    this.carInfoUseCases,
    this.userUseCases,
  ): super(const CarRegisterState()) {
    
    // We initialize the form with the values ​​of the current User
    on<CarRegisterInitEvent>((event, emit) {
      emit(
        state.copyWith(
          formKey: formKey,
          formKeyInsurance: formKeyInsurance
        ));
    });

    on<NextStep>((event, emit) {
      if (state.currentStep < 1) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStep>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
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

    // Insurance Events
    on<InsuranceCompanyChanged>((event, emit) {
      emit(
        state.copyWith(
          insuranceCompany: BlocFormItem(
            value: event.insuranceCompanyInput.value,
            error: event.insuranceCompanyInput.value.isEmpty ? 'Ingresá la compañía de seguros' : null
          ),
          formKeyInsurance: formKeyInsurance
        )
      );
    });

    on<InsuranceTypeChanged>((event, emit) {
      emit(
        state.copyWith(
          insuranceType: BlocFormItem(
            value: event.insuranceTypeInput.value,
            error: event.insuranceTypeInput.value.isEmpty ? 'Ingresá el tipo de seguro' : null
          ),
          formKeyInsurance: formKeyInsurance
        )
      );
    });

    on<InsuranceExpirationChanged>((event, emit) {
      emit(
        state.copyWith(
          insuranceExpiration: BlocFormItem(
            value: event.insuranceExpirationInput.value,
            error: event.insuranceExpirationInput.value.isEmpty ? 'Ingresá la fecha de expiración del seguro' : null
          ),
          formKeyInsurance: formKeyInsurance
        )
      );
    });

    on<PolicyNumberChanged>((event, emit) {
      emit(
        state.copyWith(
          policyNumber: BlocFormItem(
            value: event.policyNumberInput.value,
            error: event.policyNumberInput.value.isEmpty ? 'Ingresá el número de póliza' : null
          ),
          formKeyInsurance: formKeyInsurance
        )
      );
    });

    on<CuilCuitChanged>((event, emit) {
      emit(
        state.copyWith(
          cuilCuit: BlocFormItem(
            value: event.cuilCuitInput.value,
            error: event.cuilCuitInput.value.isEmpty ? 'Ingresá tu Nro de CUIL o CUIT' : null
          ),
          formKeyInsurance: formKeyInsurance
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
      print('Compañía de Seguros: ${state.insuranceCompany.value}');
      print('Tipo Seguro: ${state.insuranceType.value}');
      print('Expiración del Seguro: ${state.insuranceExpiration.value}');
      print('Número de Póliza: ${state.policyNumber.value}');
      print('CUIL CUIT: ${state.cuilCuit.value}');

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          response: Loading(),
          formKey: formKey,
          formKeyInsurance: formKeyInsurance
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
          color: state.color.value,
          insuranceCompany: state.insuranceCompany.value,
          insuranceType: state.insuranceType.value,
          insuranceExpiration: state.insuranceExpiration.value,
          policyNumber: int.parse(state.policyNumber.value),
          cuilCuit: int.parse(state.cuilCuit.value),
        )
      );

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          response: response,
          formKey: formKey,
          formKeyInsurance: formKeyInsurance
        )
      );
    });

    on<UpdateUserSession>((event, emit) async {
      Success<User> userDetailRes = await userUseCases.getUserDetailUseCase.run();
      print('Succes User Res: $userDetailRes');
      
      // Update User Session Local
      User userDetail = userDetailRes.data;
      await authUseCases.updateUserSession.run(userDetail);
    });
  }
}