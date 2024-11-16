
import 'dart:io';

import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/userUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateEvent.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {

  AuthUseCases authUseCases;
  UserUseCases userUseCases;
  final formKey = GlobalKey<FormState>();

  // Constructor
  ProfileUpdateBloc(
    this.authUseCases,
    this.userUseCases
  ): super(ProfileUpdateState()) {
    
    // We initialize the form with the values ​​of the current User
    on<ProfileUpdateInitEvent>((event, emit) {
      emit(
        state.copyWith(
          id: event.user?.idUser,
          name: BlocFormItem(value: event.user?.name ?? ''),
          lastName: BlocFormItem(value: event.user?.lastName ?? ''),
          phone: BlocFormItem(value: event.user?.phone?.toString() ?? ''),
          address: BlocFormItem(value: event.user?.address ?? ''),
          contactName: BlocFormItem(value: event.user?.contactName ?? ''),
          contactLastName: BlocFormItem(value: event.user?.contactLastName ?? ''),
          contactPhone: BlocFormItem(value: event.user?.contactPhone?.toString() ?? ''),
        )
      );
    });

    on<NameChanged>((event, emit) {
      emit(
        state.copyWith(
          name: BlocFormItem(
            value: event.nameInput.value,
            error: event.nameInput.value.isEmpty ? 'Ingresa tu nombre' : null
          ),
          formKey: formKey
        )
      );
    });

    on<LastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          lastName: BlocFormItem(
            value: event.lastNameInput.value,
            error: event.lastNameInput.value.isEmpty ? 'Ingresa tu apellido' : null
          ),
          formKey: formKey
        )
      );
    });

    on<PhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          phone: BlocFormItem(
            value: event.phoneInput.value,
            error: event.phoneInput.value.isEmpty ? 'Ingresa tu telefono' : null
          ),
          formKey: formKey
        )
      );
    });

    on<AddressChanged>((event, emit) {
      emit(
        state.copyWith(
          address: BlocFormItem(
            value: event.addressInput.value,
            error: event.addressInput.value.isEmpty ? 'Ingresa tu direccion' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ContactNameChanged>((event, emit) {
      emit(
        state.copyWith(
          contactName: BlocFormItem(
            value: event.contactNameInput.value,
            error: event.contactNameInput.value.isEmpty ? 'Ingresa el nombre de tu contacto' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ContactLastNameChanged>((event, emit) {
      emit(
        state.copyWith(
          contactLastName: BlocFormItem(
            value: event.contactLastNameInput.value,
            error: event.contactLastNameInput.value.isEmpty ? 'Ingresa el apellido de tu contacto' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ContactPhoneChanged>((event, emit) {
      emit(
        state.copyWith(
          contactPhone: BlocFormItem(
            value: event.contactPhoneInput.value,
            error: event.contactPhoneInput.value.isEmpty ? 'Ingresa el telefono de tu contacto' : null
          ),
          formKey: formKey
        )
      );
    });

    on<PickImage>((event, emit) async {
      // Library object
      final ImagePicker picker = ImagePicker();

      // Variable to capture the selected photo
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) { // I check if the user selected a valid image
        emit(
           state.copyWith(
            image: File(image.path),
            formKey: formKey
          )
        );
      }
    });

    on<TakePhoto>((event, emit) async {
      // Library object
      final ImagePicker picker = ImagePicker();
      
      // Variable to capture the photo
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null) { // I check if the user took a valid image
        emit(
           state.copyWith(
            image: File(image.path),
            formKey: formKey
          )
        );
      }
    });

    on<FormSubmit>((event, emit) async {
      print('Nombe: ${ state.name.value }');
      print('Apellido: ${ state.lastName.value }');   
      print('Telefono: ${ state.phone.value }');
      print('Direccion: ${ state.address.value }');
      print('Contact name: ${ state.contactName.value }');
      print('Contact last name: ${ state.contactLastName.value }');
      print('Contact phone: ${ state.contactPhone.value }');

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          response: Loading(),
          formKey: formKey
        )
      );

      // PARA QUE APAREZCA El estado de Loading (circle) - Tirar el Back y que quede cargando - ELIMINAR
      Resource response = await userUseCases.update.run(state.id, state.toUser(), state.image);

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          response: response,
          formKey: formKey
        )
      );
    });

    on<UpdateUserSession>((event, emit) async {
      // I get the session information
      AuthResponse authResponse = await authUseCases.getUserSession.run();
      
      // Set user values
      authResponse.user!.name = event.user.name;
      authResponse.user!.lastName = event.user.lastName;
      authResponse.user!.studentFile = event.user.studentFile;
      authResponse.user!.dni = event.user.dni;
      authResponse.user!.phone = event.user.phone;
      authResponse.user!.address = event.user.address;
      authResponse.user!.contactName = event.user.contactName;
      authResponse.user!.contactLastName = event.user.contactLastName;
      authResponse.user!.contactPhone = event.user.contactPhone;
      authResponse.user!.photoUser = event.user.photoUser;
      await authUseCases.saveUserSession.run(authResponse);
    });
  }
}