import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:equatable/equatable.dart';

class RolesState extends Equatable {

  // Listando todos los roles que tiene la BD
  final List<Role>? roles;

  const RolesState({
    this.roles
  });

  // Cambiando el estado de la Lista de roles
  RolesState copyWith({
    List<Role>? roles
  }) {
    return RolesState(
      roles: roles
    );
  }

  @override
  List<Object?> get props => [roles];

}