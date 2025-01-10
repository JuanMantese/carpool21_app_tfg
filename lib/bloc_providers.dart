import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/injection.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/drivers_position_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/user_use_cases.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/bloc/loginBloc.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/bloc/loginEvent.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/register_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/info/bloc/car_info_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/car_update_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/create_trip_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/home/bloc/driver_home_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/tripDetail/bloc/trip_detail_bloc.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_bloc.dart';
import 'package:carpool_21_app/src/views/driver/trips/bloc/trips_event.dart';
import 'package:carpool_21_app/src/screens/pages/errors/bloc/error_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passenger_home_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driver_map_booking_info_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/widgets/map/bloc/map_bloc.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profile_info_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profile_info_event.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profile_update_bloc.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [

  // Socket IO
  BlocProvider<SocketIOBloc>(create: (context) => SocketIOBloc(locator<SocketUseCases>())),

  BlocProvider<LoginBloc>(create: (context) => LoginBloc(locator<AuthUseCases>())..add(LoginInitEvent())),
  BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(locator<AuthUseCases>())..add(RegisterInitEvent())),
  // BlocProvider<RolesBloc>(create: (context) => RolesBloc(locator<AuthUseCases>())..add(GetRolesList())),
  
  // Views
  BlocProvider<PassengerHomeViewBloc>(create: (context) => PassengerHomeViewBloc(
    locator<AuthUseCases>(), 
    locator<ReserveUseCases>()
  )),
  BlocProvider<DriverHomeViewBloc>(create: (context) => DriverHomeViewBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>(), 
    locator<DriverTripRequestsUseCases>()
  )),

  // Passenger Screens
  BlocProvider<PassengerHomeBloc>(create: (context) => PassengerHomeBloc(
    locator<AuthUseCases>(), 
    locator<ReserveUseCases>()
  )),
  BlocProvider<TripsAvailableBloc>(create: (context) => TripsAvailableBloc(
    locator<AuthUseCases>(), 
    locator<DriversPositionUseCases>(), 
    locator<DriverTripRequestsUseCases>(), 
    locator<SocketUseCases>(), 
    context.read<SocketIOBloc>()
  )),
  BlocProvider<TripAvailableDetailBloc>(create: (context) => TripAvailableDetailBloc(
    locator<AuthUseCases>(), 
    locator<GeolocationUseCases>(), 
    locator<DriverTripRequestsUseCases>(), 
    locator<ReserveUseCases>(), 
    context.read<SocketIOBloc>()
  )),
  BlocProvider<ReserveDetailBloc>(create: (context) => ReserveDetailBloc(
    locator<GeolocationUseCases>(), 
    locator<ReserveUseCases>(), 
    locator<DriverTripRequestsUseCases>()
  )),
  BlocProvider<ReservesBloc>(create: (context) => ReservesBloc(
    locator<AuthUseCases>(), 
    locator<ReserveUseCases>(), 
    locator<SocketUseCases>(), 
    context.read<SocketIOBloc>()
  )..add(GetReservesAll())),

  // Driver Screens
  BlocProvider<DriverHomeBloc>(create: (context) => DriverHomeBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>(), 
    locator<DriverTripRequestsUseCases>()
  )),
  BlocProvider<DriverMapFinderBloc>(create: (context) => DriverMapFinderBloc(
    locator<GeolocationUseCases>(), 
    locator<SocketUseCases>(), 
    context.read<SocketIOBloc>()
  )..add(DriverMapFinderInitEvent())),
  BlocProvider<DriverMapBookingInfoBloc>(create: (context) => DriverMapBookingInfoBloc(
    locator<GeolocationUseCases>(), 
    locator<DriverTripRequestsUseCases>()
  )),
  BlocProvider<CreateTripBloc>(create: (context) => CreateTripBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>(), 
    locator<DriverTripRequestsUseCases>(), 
    context.read<SocketIOBloc>()
  )),
  BlocProvider<TripDetailBloc>(create: (context) => TripDetailBloc(
    locator<GeolocationUseCases>(), 
    locator<DriverTripRequestsUseCases>()
  )),
  BlocProvider<TripsBloc>(create: (context) => TripsBloc(
    locator<AuthUseCases>(), 
    locator<DriverTripRequestsUseCases>(),
    locator<SocketUseCases>(), 
    context.read<SocketIOBloc>()
  )..add(GetTripsAll())),
  BlocProvider<DriverMapLocationBloc>(create: (context) => DriverMapLocationBloc(
    locator<AuthUseCases>(), 
    locator<GeolocationUseCases>(), 
    locator<DriversPositionUseCases>(), 
    locator<SocketUseCases>(), 
    context.read<SocketIOBloc>()
  )),
  
  // Profile Screens
  BlocProvider<ProfileInfoBloc>(create: (context) => ProfileInfoBloc(locator<AuthUseCases>())..add(GetUserInfo())),
  BlocProvider<ProfileUpdateBloc>(create: (context) => ProfileUpdateBloc(locator<AuthUseCases>(), locator<UserUseCases>())),
  
  // Vehícle Screens
  BlocProvider<CarListBloc>(create: (context) => CarListBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>()
  )),
  BlocProvider<CarInfoBloc>(create: (context) => CarInfoBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>()
  )),
  BlocProvider<CarRegisterBloc>(create: (context) => CarRegisterBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>(), 
    locator<UserUseCases>()
  )),
  BlocProvider<CarUpdateBloc>(create: (context) => CarUpdateBloc(
    locator<AuthUseCases>(), 
    locator<CarInfoUseCases>()
  )),

  // Generic Providers
  BlocProvider<NavigationBloc>(create: (context) => NavigationBloc(locator<AuthUseCases>())),
  BlocProvider<ErrorBloc>(create: (context) => ErrorBloc()),

  // Map Widget  
  BlocProvider(create: (context) => MapBloc()),
];