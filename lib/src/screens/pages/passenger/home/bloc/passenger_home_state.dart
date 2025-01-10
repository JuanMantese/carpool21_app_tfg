import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart';
import 'package:equatable/equatable.dart';

class PassengerHomeState extends Equatable {
  
  final int pageIndex;

  // Obteniendo toda la informacion de sesion del usuario
  final List<Role>? roles;
  final User? currentUser;
  final UsersService? userService;
  final TripDetail? currentReserve;
  final ReservesAll? reservesAll;

  const PassengerHomeState({
    this.pageIndex = 0,
    this.roles,
    this.currentUser,
    this.userService,
    this.currentReserve,
    this.reservesAll
  });

  PassengerHomeState copyWith({
    int? pageIndex,
    List<Role>? roles,
    User? currentUser,
    UsersService? userService,
    TripDetail? currentReserve,
    ReservesAll? reservesAll,
  }) {
    return PassengerHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      roles: roles ?? this.roles,
      currentUser: currentUser ?? this.currentUser,
      userService: userService ?? this.userService,
      currentReserve: currentReserve ?? this.currentReserve,
      reservesAll: reservesAll ?? this.reservesAll
    );
  }
  
  @override
  List<Object?> get props => [
    pageIndex, 
    roles, 
    currentRole, 
    userService, 
    currentReserve, 
    reservesAll
  ];
}
