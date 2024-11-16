import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/tripsAll.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:equatable/equatable.dart';

enum DriverHomeViewStatus { initial, loading, success, error }

class DriverHomeViewState extends Equatable {
  
  final int pageIndex;
  final DriverHomeViewStatus responseStatus;
  final String? errorMessage;

  // Obteniendo toda la informacion de sesion del usuario
  final User? user;
  final List<Role>? roles;
  final User? currentUser;
  final UsersService? userService;
  final List<CarInfo>? carList;
  final TripsAll? driverTripAll;

  DriverHomeViewState({
    this.responseStatus = DriverHomeViewStatus.initial,
    this.errorMessage,
    this.pageIndex = 0,
    this.user,
    this.roles,
    this.currentUser,
    this.userService,
    this.carList,
    this.driverTripAll,
  });

  DriverHomeViewState copyWith({
    DriverHomeViewStatus? responseStatus,
    String? errorMessage,
    User? user,
    int? pageIndex,
    List<Role>? roles,
    User? currentUser,
    UsersService? userService,
    List<CarInfo>? carList,
    TripsAll? driverTripAll
  }) {
    return DriverHomeViewState(
      responseStatus: responseStatus ?? this.responseStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      pageIndex: pageIndex ?? this.pageIndex,
      user: user ?? this.user,
      roles: roles ?? this.roles,
      currentUser: currentUser ?? this.currentUser,
      userService: userService ?? this.userService,
      carList: carList ?? this.carList,
      driverTripAll: driverTripAll ?? this.driverTripAll
    );
  }

  List<Object?> get props => [
    responseStatus,
    errorMessage,
    pageIndex,
    user,
    roles,
    currentUser,
    userService,
    carList,
    driverTripAll,
  ];

}