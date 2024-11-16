// navigation_state.dart
import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:equatable/equatable.dart';

enum NavigationType { 
  inicioPassenger,
  inicioDriver, 
  reservas, 
  viaje,
  perfil 
}

class NavigationState extends Equatable {
  final NavigationType navigationType;
  final List<Role>? roles;
  final User? currentUser;
  final UsersService? userService;

  const NavigationState({
    required this.navigationType,
    this.roles,
    this.currentUser,
    this.userService,
  });

  // Cambiando el estado de la Lista de roles o el tipo de navegación
  NavigationState copyWith({
    NavigationType? navigationType,
    List<Role>? roles,
    User? currentUser,
    UsersService? userService,

  }) {
    return NavigationState(
      navigationType: navigationType ?? this.navigationType,
      roles: roles ?? this.roles,
      currentUser: currentUser ?? this.currentUser,
      userService: userService ?? this.userService,
    );
  }

  @override
  List<Object?> get props => [navigationType, roles];
}