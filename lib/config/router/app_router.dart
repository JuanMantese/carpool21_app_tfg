
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/login.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/register.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/carInfo.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/carList.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/carRegister.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/carUpdate.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/createTrip.dart';
import 'package:carpool_21_app/src/screens/pages/driver/home/driverHome.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/driverMapBookingInfo.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapFinder/driverMapFinder.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/driverMapLocation.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/tripDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/passengerHome.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/reserveDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/tripAvailableDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/tripsAvailable.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/profileInfo.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/profileUpdate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  observers: [routeObserver],
  // initialLocation: '/passenger/0',
  initialLocation: '/login',
  routes: [
    // ShellRoute(
    //   navigatorKey: GlobalKey<NavigatorState>(),
    //   builder: (context, state, child) {
    //     return PassengerHomePage(screenView: child);
    //   },
    //   routes: [
    //     GoRoute(
    //       path: '/',
    //       name: 'Passenger Home',
    //       builder: (context, state) => const PassengerHomeContent(),
    //       routes: [
    //         GoRoute(
    //           path: 'passenger/request/trips',
    //           builder: (context, state) => const TripsAvailablePage(),
    //         ),
    //       ]
    //     ),
    //     GoRoute(
    //       path: '/reserves',
    //       name: 'All Reserves',
    //       builder: (context, state) => const ReservesContent(),
    //     )
    //   ]
    // )

    /* Login ----- */
    GoRoute(
      path: '/login',
      name: 'Login Screen',
      builder: (context, state) => const LoginPage(),
    ),

    /* Register ----- */
    GoRoute(
      path: '/register',
      name: 'Register Screen',
      builder: (context, state) => const RegisterPage(),
    ),

    /* Profile ----- */
    GoRoute(
      path: '/profile',
      name: 'Profile Screen',
      builder: (context, state) => const ProfileInfoPage(),
      routes: [
        GoRoute(
          path: 'update',
          name: 'Profile Update Screen',
          builder: (context, state) {
            final user = state.extra as User?;
            return ProfileUpdatePage(user: user);
          },
        ),
      ]
    ),

    /* Vehicle ----- */
    GoRoute(
      path: '/car/list',
      name: 'Car List Screen',
      builder: (context, state) => const CarListPage(),
      routes: [
        GoRoute(
          path: 'info',
          name: 'Car Info Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return CarInfoPage(arguments: arguments);
          },
        ),
        GoRoute(
          path: 'register',
          name: 'Car Register Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return CarRegisterPage(arguments: arguments);
          },
        ),
        GoRoute(
          path: 'update',
          name: 'Car Update Screen',
          builder: (context, state) {
            final car = state.extra as CarInfo?;
            return CarUpdatePage(car: car);
          },
        ),
      ]
    ),

    /* Passenger Screens ----- */
    GoRoute(
      path: '/passenger/:screen',
      name: 'Passenger Screens',
      builder: (context, state) {
        final pageIndex = int.parse( state.pathParameters['screen'] ?? '0' );
        return PassengerHomePage( pageIndex: pageIndex );
      },
      routes: [
        GoRoute(
          path: 'request/trips',
          name: 'Request Trips Screen',
          builder: (context, state) => const TripsAvailablePage(),
          routes: [
            GoRoute(
              path: 'detail',
              name: 'Request Trips Detail Screen',
              builder: (context, state) {
                final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
                return TripAvailableDetailPage(arguments: arguments);
              },
            ),
          ]
        ),
        GoRoute(
          path: 'reserve/detail',
          name: 'Reserve Detail Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return ReserveDetailPage(arguments: arguments);
          },
        ),
      ]
    ),

    /* Driver Screens ----- */
    GoRoute(
      path: '/driver/:screen',
      name: 'Driver Screens',
      builder: (context, state) {
        final pageIndex = int.parse( state.pathParameters['screen'] ?? '0' );
        return DriverHomePage( pageIndex: pageIndex );
      },
      routes: [
        GoRoute(
          path: 'finder',
          name: 'Finder Screen',
          builder: (context, state) => const DriverMapFinder(),
        ),
        GoRoute(
          path: 'map/booking',
          name: 'Map Booking Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return DriverMapBookingInfo(arguments: arguments);
          },
        ),
        GoRoute(
          path: 'createTrip',
          name: 'CreateTrip Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return CreateTripPage(arguments: arguments);
          },
        ),
        GoRoute(
          path: 'trip/detail',
          name: 'Trip Detail Screen',
          builder: (context, state) {
            final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;
            return TripDetailPage(arguments: arguments);
          },
        ),
        GoRoute(
          path: 'location',
          name: 'Location Screen',
          builder: (context, state) => const DriverMapLocation(),
        ),
      ]
    ),

    // Al no encontrar una ruta, redirijo a la Home del Pasajero
    GoRoute(
      path: '/',
      redirect: ( _ , __ ) => '/passenger/0',
    ),
  ]
);