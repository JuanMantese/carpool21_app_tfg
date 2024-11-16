
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationBloc.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationEvent.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart' as globals;
import 'package:go_router/go_router.dart';

class CustomNavigation extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey; // Key for Scaffold

  final List<Role> roles;
  final User currentUser;
  final int currentIndex;

  CustomNavigation({
    super.key, 
    required this.scaffoldKey,
    required this.roles,
    required this.currentUser,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    print('Global Key ${globals.currentRole}');
    return BlocProvider(
      create: (_) => NavigationBloc(GetIt.instance<AuthUseCases>()),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          // final currentIndex = _getCurrentIndex(context, globals.currentRole, state.navigationType);

          // return Scaffold(
          //   key: _scaffoldKey,
          //   endDrawer: CustomDrawer(
          //     roles: roles,
          //     currentUser: currentUser,
          //   ), // Add Drawer to the Scaffold
          //   body: Center(
          //     child: _buildPage(state),
          //   ),
          //   bottomNavigationBar: BottomNavigationBar(
          //     type: BottomNavigationBarType.fixed,
          //     currentIndex: currentIndex,
          //     selectedItemColor: const Color(0xFF00A98F),
          //     unselectedItemColor: const Color.fromARGB(255, 111, 111, 111),
          //     onTap: (index) {
          //       _onItemTapped(context, index, globals.currentRole);
          //     },
          //     items: _buildBottomNavigationBarItems(globals.currentRole, state),
          //   ),
          // );
          print('currentIndex $currentIndex');
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: const Color(0xFF00A98F),
            unselectedItemColor: const Color.fromARGB(255, 111, 111, 111),
            onTap: (index) {
              _onItemTapped(context, index, globals.currentRole);
            },
            items: _buildBottomNavigationBarItems(globals.currentRole, state, currentIndex),
          );
        },
      ),
    );
  }

  // Action Navigation Bar Items - Rol validation
  void _onItemTapped(BuildContext context, int index, String currentRole) {
    if (currentRole == 'passenger') {
      switch (index) {
        case 0:
          // context.read<NavigationBloc>().add(ShowInicio());
          context.go('/passenger/0');
          break;
        case 1:
          // context.read<NavigationBloc>().add(ShowReservas());
          context.go('/passenger/1');
          break;
        case 2:
          scaffoldKey.currentState?.openEndDrawer(); // Open Drawer for Profile
          break;
      }
    } else if (currentRole == 'driver') {
      switch (index) {
        case 0:
          context.read<NavigationBloc>().add(ShowInicio());
          break;
        case 1:
          context.read<NavigationBloc>().add(ShowViaje());
          break;
        case 2:
          scaffoldKey.currentState?.openEndDrawer(); // Open Drawer for Profile
          break;
      }
    }
  }

  // List of Navigation Bar Items - Rol validation
  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
    String currentRole, NavigationState state, int currentIndex
  ) {
    if (currentRole == 'passenger') {
      return [
        _buildBottomNavigationBarItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          // isActive: state.navigationType == NavigationType.inicioPassenger,
          isActive: currentIndex == 0,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.event,
          label: 'Reservas',
          // isActive: state.navigationType == NavigationType.reservas,
          isActive: currentIndex == 1,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.account_circle_outlined,
          label: 'Perfil',
          // isActive: state.navigationType == NavigationType.perfil,
          isActive: currentIndex == 3,
        ),
      ];
    } else if (currentRole == 'driver') {
      return [
        _buildBottomNavigationBarItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          isActive: state.navigationType == NavigationType.inicioDriver,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.directions_car_rounded,
          label: 'Viaje',
          isActive: state.navigationType == NavigationType.viaje,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.account_circle_outlined,
          label: 'Perfil',
          isActive: state.navigationType == NavigationType.perfil,
        ),
      ];
    } else {
      return [];
    }
  }

  // Single Bottom Navigation Bar Item
  BottomNavigationBarItem _buildBottomNavigationBarItem(
    {required IconData icon, required String label, required bool isActive}
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        width: isActive ? 42 : 24,
        height: isActive ? 42 : 24,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00A98F) : Colors.transparent,
          shape: BoxShape.circle),
        child: Icon(
          icon,
          color: isActive
            ? Colors.white
            : const Color.fromARGB(255, 111, 111, 111),
          size: isActive ? 30 : 24,
        ),
      ),
      label: label,
      backgroundColor: isActive ? const Color(0xFF00A98F) : Colors.transparent,
    );
  }

  // Widget _buildPage(NavigationState state) {
  //   switch (state.navigationType) {
  //     case NavigationType.inicioPassenger:
  //       return BlocBuilder<PassengerHomeBloc, PassengerHomeState>(
  //         builder: (context, passengerState) {
  //           return PassengerHomeContent1();
  //         },
  //       );
  //     case NavigationType.inicioDriver:
  //       return BlocBuilder<DriverHomeBloc, DriverHomeState>(
  //         builder: (context, driverState) {
  //           return DriverHomeContent(driverState);
  //         },
  //       );
  //     // case NavigationType.reservas:
  //     //   return BlocBuilder<ReservesBloc, ReservesState>(
  //     //     builder: (context, reservesState) {
  //     //       return ReservesContent(reservesState);
  //     //     },
  //     //   );
  //     case NavigationType.viaje:
  //       return BlocBuilder<TripsBloc, TripsState>(
  //         builder: (context, tripsState) {
  //           return TripsContent(tripsState);
  //         },
  //       );
  //     default:
  //       return const Text('Page not found');
  //   }
  // }

  // Obtengo el valor actual del indice dependiendo de donde se encuentra el usuario
  int _getCurrentIndex(BuildContext context, String currentRole, NavigationType navigationType) {
    final GoRouterState state = GoRouterState.of(context);
    final String currentLocation = state.uri.toString();
    print('Aca: $currentLocation');

    if (currentRole == 'passenger') {
      // switch (navigationType) {
      //   case NavigationType.inicioPassenger:
      //     return 0;
      //   case NavigationType.reservas:
      //     return 1;
      //   case NavigationType.perfil:
      //     return 2;
      //   default:
      //     return 0;
      // }

      // IMPLEMENTACION CON SHELL ROUTE
      // switch (currentLocation) {
      //   case '/':
      //   print('acaaaa');
      //     return 0;
      //   case '/reserves':
      //     return 1;
      //   case '/profile':
      //     return 2;
      //   default:
      //     return 0;
      // }
    } else if (currentRole == 'driver') {
      // switch (navigationType) {
      //   case NavigationType.inicioDriver:
      //     return 0;
      //   case NavigationType.viaje:
      //     return 1;
      //   case NavigationType.perfil:
      //     return 2;
      //   default:
      //     return 0;
      // }

      // IMPLEMENTACION CON SHELL ROUTE
      // switch (currentLocation) {
      //   case '/driver':
      //     return 0;
      //   case '/trips':
      //     return 1;
      //   case '/profile':
      //     return 2;
      //   default:
      //     return 0;
      // }
    }
    return 0; // Default index
  }
}
