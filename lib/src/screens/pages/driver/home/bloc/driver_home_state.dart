import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:equatable/equatable.dart';

class DriverHomeState extends Equatable {
  
  final int pageIndex;

  // Obteniendo toda la informacion de sesion del usuario
  final User? user;
  final List<Role>? roles;
  final User? currentUser;
  final UsersService? userService;
  final List<CarInfo>? carList;
  final TripsAll? driverTripAll;

  const DriverHomeState({
    this.pageIndex = 0,
    this.user,
    this.roles,
    this.currentUser,
    this.userService,
    this.carList,
    this.driverTripAll,
  });

  DriverHomeState copyWith({
    int? pageIndex,
    User? user,
    List<Role>? roles,
    User? currentUser,
    UsersService? userService,
    List<CarInfo>? carList,
    TripsAll? driverTripAll
  }) {
    return DriverHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      user: user ?? this.user,
      roles: roles ?? this.roles,
      currentUser: currentUser ?? this.currentUser,
      userService: userService ?? this.userService,
      carList: carList ?? this.carList,
      driverTripAll: driverTripAll ?? this.driverTripAll
    );
  }

  @override
  List<Object?> get props => [
    pageIndex,
    user,
    roles,
    currentUser,
    userService,
    carList,
    driverTripAll,
  ];

}