import 'package:carpool_21_app/blocProviders.dart';
import 'package:carpool_21_app/config/constants/enviroment.dart';
import 'package:carpool_21_app/config/router/app_router.dart';
import 'package:carpool_21_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    
  await Environment.initEnviroment(); 

  await Hive.initFlutter();

  await configureDependencies();
  runApp(const CarPool21());
}

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CarPool21 extends StatelessWidget {
  const CarPool21({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp.router(
        key: const ValueKey('CarPool21_App'),
        title: 'Carpool 21',
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
        // navigatorObservers: [routeObserver],
        // initialRoute: '/login',
        // routes: {
        //   '/login': (context) => const LoginPage(),
        //   '/register': (context) => const RegisterPage(),
        //   // '/roles': (context) => const RolesPage(), // ELIMINAR - Por ahora lo utilizo, pero vamos a manejar el cambio de roles desde el Drawer
        //   '/profile': (context) => const ProfileInfoPage(),
        //   '/profile/update': (context) => const ProfileUpdatePage(),
          
        //   '/car/list': (context) => const CarListPage(),
        //   '/car/info': (context) => const CarInfoPage(),
        //   '/car/register': (context) => const CarRegisterPage(),
        //   '/car/update': (context) => const CarUpdatePage(),
          
        //   '/passenger/home': (context) => const PassengerHomePage(screenView: PassengerHomeContent()),
        //   '/passenger/reserves': (context) => const ReservesPage(),
        
        //   '/passenger/request/trips': (context) => const TripsAvailablePage(),
        //   '/passenger/request/trips/detail': (context) => const TripAvailableDetailPage(),
        //   '/passenger/reserve/detail': (context) => const ReserveDetailPage(),


        //   '/driver/home': (context) => const DriverHomePage(),
        //   '/driver/finder': (context) => const DriverMapFinder(),
        //   '/driver/map/booking': (context) => const DriverMapBookingInfo(),
        //   '/driver/createTrip': (context) => const CreateTripPage(),
        //   '/driver/trip/detail': (context) => const TripDetailPage(),
        //   '/driver/location': (context) => const DriverMapLocation(),
        // },
        // home: const LoginPage()
      ),
    );
  }
}
