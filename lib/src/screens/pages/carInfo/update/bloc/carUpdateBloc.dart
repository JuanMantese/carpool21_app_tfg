
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/carUpdateEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/carUpdateState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarUpdateBloc extends Bloc<CarUpdateEvent, CarUpdateState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  final formKey = GlobalKey<FormState>();

  // Constructor
  CarUpdateBloc(
    this.authUseCases,
    this.carInfoUseCases
  ): super(CarUpdateState()) {
    
    // We initialize the form with the values ​​of the current User
    on<CarUpdateInitEvent>((event, emit) {
      emit(
        state.copyWith(
          id: event.car?.idDriver,
          brand: BlocFormItem(value: event.car?.brand ?? ''),
          model: BlocFormItem(value: event.car?.model ?? ''),
          patent: BlocFormItem(value: event.car?.patent ?? ''),
          color: BlocFormItem(value: event.car?.color ?? ''),
          year: BlocFormItem(value: event.car?.year.toString() ?? ''),
          nroGreenCard: BlocFormItem(value: event.car?.nroGreenCard.toString() ?? ''),
        )
      );
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

    on<YearChanged>((event, emit) {
      emit(
        state.copyWith(
          year: BlocFormItem(
            value: event.yearInput.value,
            error: event.yearInput.value.isEmpty ? 'Ingresá el Año del Vehiculo' : null
          ),
          formKey: formKey
        )
      );
    });

    on<FormSubmit>((event, emit) async {
      print('Marca: ${ state.brand.value }');
      print('Modelo: ${ state.model.value }');
      print('Patente: ${ state.patent.value }');
      print('Color: ${ state.color.value }');      
      print('Cedula Verde: ${ state.nroGreenCard.value }');
      print('Datos del Seguro: ${ state.year.value }');

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          response: Loading(),
          formKey: formKey
        )
      );

      // ELIMINAR - PARA QUE APAREZCA El estado de Loading (circle) - Tirar el Back y que quede cargando
      Resource response = await carInfoUseCases.updateCarInfo.run(state.id, state.toCarInfo());

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          response: response,
          formKey: formKey
        )
      );
    });

    // on<UpdateUserSession>((event, emit) async {
    //   // I get the session information
    //   AuthResponse authResponse = await authUseCases.getUserSession.run();
      
    //   // Set user values
    //   authResponse.user.name = event.user.name;
    //   authResponse.user.lastName = event.user.lastName;
    //   authResponse.user.studentFile = event.user.studentFile;
    //   authResponse.user.dni = event.user.dni;
    //   authResponse.user.phone = event.user.phone;
    //   authResponse.user.address = event.user.address;
    //   authResponse.user.contactName = event.user.contactName;
    //   authResponse.user.contactLastName = event.user.contactLastName;
    //   authResponse.user.contactPhone = event.user.contactPhone;
    //   authResponse.user.photoUser = event.user.photoUser;
    //   await authUseCases.saveUserSession.run(authResponse);
    // });
  }
}