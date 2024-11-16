// navigation_bloc.dart
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationEvent.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart' as globals;

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {


  AuthUseCases authUseCases;

  NavigationBloc(this.authUseCases) : super(NavigationState(navigationType: globals.currentRole == 'passenger' ? NavigationType.inicioPassenger : NavigationType.inicioDriver)) {
    on<NavigationEvent>((event, emit) {
      if (event is ShowInicio) {
        emit(
          state.copyWith(
            navigationType: globals.currentRole == 'passenger' 
              ? NavigationType.inicioPassenger : NavigationType.inicioDriver
          )
        );
      } else if (event is ShowReservas && globals.currentRole == 'passenger') {
        emit(
          state.copyWith(
            navigationType: NavigationType.reservas
          )
        );
      } else if (event is ShowViaje && globals.currentRole == 'driver') {
        emit(
          state.copyWith(
            navigationType: NavigationType.viaje
          )
        );
      } else if (event is ShowPerfil) {
        emit(
          state.copyWith(
            navigationType: NavigationType.perfil
          )
        );
      }
    });

    on<Logout>((event, emit) async {
      await authUseCases.logout.run();
    });

    on<GetUserInfo>((event, emit) async {
      AuthResponse? authResponse = await authUseCases.getUserSession.run();
      if (authResponse != null && authResponse.user != null) {
        print('Entro en GetUserInfo - Navigation');
        List<Role> roles = authResponse.user!.roles?.map((role) => role).toList() ?? [];
        print('roles $roles');
        emit(
          state.copyWith(
            roles: roles,
            currentUser: authResponse.user,
            userService: event.userService,
          )
        );
      }
    });

    on<ChangeUserRol>((event, emit) async {
      print('Entro en ChangeUserRol - Navigation -----------------------------------------');

      Success<User> userResponse = await authUseCases.changeRolUseCase.run(event.idRole);
      var userData = userResponse.data;
      print('Información Actualizada: ${userData.toJson()}');
      
      // Actualizando la información del usuario localmente
      await authUseCases.updateUserSession.run(userData);

      List<Role> roles = userData.roles?.map((role) => role).toList() ?? [];
      
      emit(
        state.copyWith(
          roles: roles,
          currentUser: userData,
        )
      );
    });
  }
}