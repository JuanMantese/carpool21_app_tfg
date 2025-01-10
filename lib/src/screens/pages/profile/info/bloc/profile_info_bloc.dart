// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profile_info_event.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profile_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfoBloc extends Bloc<ProfileInfoEvent, ProfileInfoState> {

  AuthUseCases authUseCases;

  // Constructor
  ProfileInfoBloc(this.authUseCases): super(const ProfileInfoState()) {
    
    // User Test Data
    // ignore: unused_local_variable
    final User testUser = User(
      idUser: 1,
      name: 'Juan',
      lastName: 'Mantese',
      studentFile: 'SOF01669',
      dni: 12345678,
      phone: 3517872662,
      address: '123 Calle Falsa',
      email: 'juan.mantese@example.com',
      password: 'password123',
      passwordConfirm: 'password123',
      contactName: 'Julian',
      contactLastName: 'Mantese',
      contactPhone: 3513751312,
      photoUser: 'lib/assets/img/profile-icon.png',
      notificationToken: null,
      roles: [
        Role(
          idRole: "ADMIN",
          name: "Administrador",
          route: "/roles/admin",
        ),
        Role(
          idRole: "PASSENGER",
          name: "Pasajero",
          route: "/roles/passenger",
        ),
      ],
    );

    on<GetUserInfo>((event, emit) async {
      AuthResponse? authResponse = await authUseCases.getUserSession.run();
      
      if (authResponse != null && authResponse.user != null) {
        print('Datos del usuario obtenidos - Passenger -------------------');
        print(authResponse.toJson());

        emit(
          state.copyWith(
            user: authResponse.user,
          )
        );
      } else {
        print('No se lograron obtener los datos del usuario - GetUserInfo - Profile');
      }
    }); 
  }

}