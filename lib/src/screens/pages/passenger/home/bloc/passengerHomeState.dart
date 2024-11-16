import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
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



  PassengerHomeState({
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
  List<Object?> get props => [pageIndex, roles, currentRole, userService, currentReserve, reservesAll];


  // Iniciacion del State
  // const PassengerHomeState();
  
  // @override
  // List<Object?> get props => [];

}

// class PassengerHomeInitial extends PassengerHomeState {}

// class PassengerHomeLoading extends PassengerHomeState {}

// class PassengerHomeSuccess extends PassengerHomeState {
//   final int pageIndex;
//   final List<Role>? roles;
//   final User? currentUser;
//   final UsersService? userService;
//   final TripDetail? currentReserve;
//   final ReservesAll? reservesAll;

//   const PassengerHomeSuccess({
//     this.pageIndex = 0,
//     this.roles,
//     this.currentUser,
//     this.userService,
//     this.currentReserve,
//     this.reservesAll,
//   });

//   PassengerHomeSuccess copyWith({
//     int? pageIndex,
//     List<Role>? roles,
//     User? currentUser,
//     UsersService? userService,
//     TripDetail? currentReserve,
//     ReservesAll? reservesAll,
//   }) {
//     return PassengerHomeSuccess(
//       pageIndex: pageIndex ?? this.pageIndex,
//       roles: roles ?? this.roles,
//       currentUser: currentUser ?? this.currentUser,
//       userService: userService ?? this.userService,
//       currentReserve: currentReserve ?? this.currentReserve,
//       reservesAll: reservesAll ?? this.reservesAll,
//     );
//   }

//   @override
//   List<Object?> get props => [pageIndex, roles, currentUser, userService, currentReserve, reservesAll];
// }

// class PassengerHomeError extends PassengerHomeState {
//   final String message;

//   const PassengerHomeError(this.message);

//   @override
//   List<Object?> get props => [message];
// }