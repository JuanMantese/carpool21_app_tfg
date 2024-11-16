import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/registerEvent.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/registerState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  
  AuthUseCases authUseCases;
  final formKeyRegister = GlobalKey<FormState>();

  // constructor
  RegisterBloc(
    this.authUseCases
  ): 
  super(const RegisterState()) {
    
    on<RegisterInitEvent>((event, emit) {
      emit(state.copyWith(formKeyRegister: formKeyRegister));
    });

    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: BlocFormItem(
            value: event.nameInput.value,
            error: event.nameInput.value.isEmpty ? 'Ingresá tu nombre' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<LastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          lastName: BlocFormItem(
            value: event.lastNameInput.value,
            error: event.lastNameInput.value.isEmpty ? 'Ingresá tu apellido' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<StudentFileInputChanged>((event, emit) {
      emit(
        state.copyWith(
          studentFile: BlocFormItem(
            value: event.studentFileInput.value,
            error: event.studentFileInput.value.isEmpty ? 'Ingresá tu legajo de Siglo 21' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<DniChanged>((event, emit) {
      emit(
        state.copyWith(
          dni: BlocFormItem(
            value: event.dniInput.value,
            error: event.dniInput.value.isEmpty 
              ? 'Ingresá tu D.N.I.'
              : event.dniInput.value.length != 8
                ? 'Ingresá tu D.N.I. con 8 caracteres' : null 
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<PhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          phone: BlocFormItem(
            value: event.phoneInput.value,
            error: event.phoneInput.value.isEmpty 
              ? 'Ingresá tu telefono'
              : event.phoneInput.value.length != 10 
                ? 'Ingresá tu teléfono con 10 caracteres' : null 
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<AddressChanged>((event, emit) {
      emit(
        state.copyWith(
          address: BlocFormItem(
            value: event.addressInput.value,
            error: event.addressInput.value.isEmpty ? 'Ingresá tu direccion' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: BlocFormItem(
            value: event.emailInput.value,
            error: event.emailInput.value.isEmpty ? 'Ingresá tu email' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: BlocFormItem(
            value: event.passwordInput.value,
            error: event.passwordInput.value.isEmpty 
              ? 'Ingresá una contrasena'
              : event.passwordInput.value.length < 8
                ? 'Mínimo 8 caracteres' : null 
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<PasswordConfirmChanged>((event, emit) {
      
      emit(
        state.copyWith(
          passwordConfirm: BlocFormItem(
            value: event.passwordConfirmInput.value,
            error: event.passwordConfirmInput.value.isEmpty 
              ? 'Confirmá la contraseña'
              : event.passwordConfirmInput.value.length < 8
                ? 'Mínimo 8 caracteres' 
                : event.passwordConfirmInput.value != state.password.value 
                  ? 'La contraseña no coincide'
                  : null 
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<ContactNameChanged>((event, emit) {
      emit(
        state.copyWith(
          contactName: BlocFormItem(
            value: event.contactNameInput.value,
            error: event.contactNameInput.value.isEmpty ? 'Ingresá el nombre de tu contacto' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<ContactLastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          contactLastName: BlocFormItem(
            value: event.contactLastNameInput.value,
            error: event.contactLastNameInput.value.isEmpty ? 'Ingresá el apellido de tu contacto' : null
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<ContactPhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          contactPhone: BlocFormItem(
            value: event.contactPhoneInput.value,
            error: event.contactPhoneInput.value.isEmpty 
              ? 'Ingresá el telefono de tu contacto'
              : event.contactPhoneInput.value.length != 10 
                ? 'Ingresá el teléfono con 10 caracteres' : null 
          ),
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<FormSubmit>((event, emit) async {
      print('Nombre: ${ state.name.value }');
      print('Apellido: ${ state.lastName.value }');
      print('Legajo: ${ state.studentFile.value }');
      print('DNI: ${ state.dni.value }');      
      print('Teléfono: ${ state.phone.value }');
      print('Dirección: ${ state.address.value }');
      print('Email: ${ state.email.value }');
      print('Password: ${ state.password.value }');
      print('Password Confirm: ${ state.passwordConfirm.value }');
      print('Contact name: ${ state.contactName.value }');
      print('Contact last name: ${ state.contactLastName.value }');
      print('Contact phone: ${ state.contactPhone.value }');

      int? dni = int.tryParse(state.dni.value);
      int? phone = int.tryParse(state.phone.value);
      int? contactPhone = int.tryParse(state.contactPhone.value);

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          response: Loading(),
          formKeyRegister: formKeyRegister
        )
      );

      // PARA QUE APAREZCA El estado de Loading (circle) - Tirar el Back y que quede cargando
      Resource response = await authUseCases.register.run(state.toUser());

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          response: response,
          formKeyRegister: formKeyRegister
        )
      );
    });

    on<FormReset>((event, emit) {
      state.formKeyRegister?.currentState?.reset();
    });

    on<SaveUserSession>((event, emit) async {
      await authUseCases.saveUserSession.run(event.authResponse);
    });
  }
}