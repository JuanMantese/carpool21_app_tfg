import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart';
import 'package:equatable/equatable.dart';

enum PassengerHomeViewStatus { initial, loading, success, error }

class PassengerHomeViewState extends Equatable {
  
  final int pageIndex;
  final PassengerHomeViewStatus responseStatus;
  final String? errorMessage;

  // Obteniendo toda la informacion de sesion del usuario
  final List<Role>? roles;
  final User? currentUser;
  final UsersService? userService;
  final TripDetail? currentReserve;
  final ReservesAll? reservesAll;



  PassengerHomeViewState({
    this.responseStatus = PassengerHomeViewStatus.initial,
    this.errorMessage,
    this.pageIndex = 0,
    this.roles,
    this.currentUser,
    this.userService,
    this.currentReserve,
    this.reservesAll
  });

  PassengerHomeViewState copyWith({
    PassengerHomeViewStatus? responseStatus,
    String? errorMessage,
    int? pageIndex,
    List<Role>? roles,
    User? currentUser,
    UsersService? userService,
    TripDetail? currentReserve,
    ReservesAll? reservesAll,
  }) {
    return PassengerHomeViewState(
      responseStatus: responseStatus ?? this.responseStatus,
      errorMessage: errorMessage ?? this.errorMessage,
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
    responseStatus,
    errorMessage,
    pageIndex, 
    roles, 
    currentRole, 
    userService, 
    currentReserve, 
    reservesAll
  ];

}