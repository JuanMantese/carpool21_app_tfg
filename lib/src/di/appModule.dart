
import 'package:carpool_21_app/src/data/api/apiConfig.dart';
import 'package:carpool_21_app/src/data/dataSource/local/sharedPref.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/auth_service.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/car_info_service.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/driver_trip_requests_service.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/driversPositionService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/passenger_request_service.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/reserve_service.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';
import 'package:carpool_21_app/src/data/repository-impl/auth_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/car_info_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/driver_position_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/driver_trip_requests_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/geolocation_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/passenger_request_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/reserve_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/socket_repository_impl.dart';
import 'package:carpool_21_app/src/data/repository-impl/users_repository_impl.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/repository/auth_repository.dart';
import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart';
import 'package:carpool_21_app/src/domain/repository/driver_position_repository.dart';
import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart';
import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart';
import 'package:carpool_21_app/src/domain/repository/passenger_request_repository.dart';
import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart';
import 'package:carpool_21_app/src/domain/repository/socket_repository.dart';
import 'package:carpool_21_app/src/domain/repository/users_repository.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/change_rol_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/get_user_session_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/get_user_token_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/login_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/logout_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/register_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/save_user_session_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/save_user_token_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/update_user_session_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/create_car_info_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/get_car_info_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/get_car_list_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/update_car_info_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/create_trip_request_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_all_trips_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_driver_trips_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_time_and_distance_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/get_trip_detail_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/create_driver_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/delete_driver_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/drivers_position_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/get_driver_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/create_marker_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/find_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_location_data_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_marker_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_placemark_data_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_polyline_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_position_stream_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/passenger-request/get_nerby_trip_request_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/passenger-request/passenger_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/create_reserve_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/get_all_reserves_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/get_reserve_detail_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/connect_socket_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/disconnect_socket_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/get_user_detail_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/users/update_user_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/users/user_use_cases.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';


// Here I place all the dependencies that I am going to use in the project
@module
abstract class AppModule {

  @injectable
  SharedPref get sharedPref => SharedPref();  // Local Storage

  @injectable
  Dio get dio => Dio(BaseOptions(
    baseUrl: 'http://192.168.100.205:3000',
    contentType: 'application/json',
  ));

  @injectable
  Future<String> get token async {  // User Access Token
    String token = '';
    final userSession = await sharedPref.read('user');
    if (userSession != null) {
      AuthResponse authResponse = AuthResponse.fromJson(userSession);
      token = authResponse.token;
    }
    return token;
  }

  @injectable
  ServiceHandler get serviceHandler {
    final handler = ServiceHandler();
    handler.configure(authUseCases, authService);
    return handler;
  }

  @injectable
  AuthService get authService => AuthService(dio, token); // Auth Service - Remote Storage

  @injectable
  UsersService get usersService => UsersService(serviceHandler, token); // User Service - Remote Storage

  @injectable
  CarInfoService get carInfoService => CarInfoService(serviceHandler, token); // Car Info Service - Remote Storage

  @injectable
  DriversPositionService get driversPositionService => DriversPositionService(); // Drivers Position Service - Remote Storage

  @injectable
  DriverTripRequestsService get driverTripRequestsService => DriverTripRequestsService(serviceHandler, token); // Drivers Trip Requests Service - Remote Storage

  @injectable
  PassengerRequestsService get passengerRequestsService => PassengerRequestsService(serviceHandler, token); // Passenger Requests Service - Remote Storage

  @injectable
  ReserveService get reserveService => ReserveService(serviceHandler, token); // Reserve Service - Remote Storage

  // Socket IO - Inicializando Socket IO
  Socket get socket => io(ApiConfig.API_CARPOOL21,
    OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect()  // disable auto-connection
      .build()
  );


  // Auth Repository
  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(authService, sharedPref);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    login: LoginUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    changeRolUseCase: ChangeRolUseCase(authRepository),
    saveUserSession: SaveUserSessionUseCase(authRepository),
    updateUserSession: UpdateUserSessionUseCase(authRepository),
    getUserSession: GetUserSessionUseCase(authRepository),
    saveUserTokenUseCase: SaveUserTokenUseCase(authRepository),
    getUserTokenUseCase: GetUserTokenUseCase(authRepository)
  );


  // User Repository
  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);

  @injectable
  UserUseCases get userUseCases => UserUseCases(
    update: UpdateUserUseCase(usersRepository),
    getUserDetailUseCase: GetUserDetailUseCase(usersRepository)
  );


  // Geolocation Repository
  @injectable
  GeolocationRepository get geolocationRepository => GeolocationRepositoryImpl();

  @injectable
  GeolocationUseCases get geolocationUseCases => GeolocationUseCases(
    findPosition: FindPositionUseCase(geolocationRepository),
    createMarker: CreateMarkerUseCase(geolocationRepository),
    getMarker: GetMarkerUseCase(geolocationRepository),
    getLocationData: GetLocationDataUseCase(geolocationRepository),
    getPlacemarkData: GetPlacemarkDataUseCase(geolocationRepository),
    getPolyline: GetPolylineUseCase(geolocationRepository),
    getPositionStream: GetPositionStreamUseCase(geolocationRepository),
  );


  // Car Info Repository
  @injectable
  CarInfoRepository get carInfoRepository => CarInfoRepositoryImpl(carInfoService);
 
  @injectable
  CarInfoUseCases get carInfoUseCases => CarInfoUseCases(
    createCarInfo: CreateCarInfoUseCase(carInfoRepository),
    updateCarInfo: UpdateCarInfoUseCase(carInfoRepository),
    getCarInfo: GetCarInfoUseCase(carInfoRepository),
    getCarList: GetCarListUseCase(carInfoRepository),
  );


  // Drivers Position Repository
  @injectable
  DriverPositionRepository get driverPositionRepository => DriversPositionRepositoryImpl(driversPositionService);
 
  @injectable
  DriversPositionUseCases get driversPositionUseCases => DriversPositionUseCases(
    createDriverPosition: CreateDriverPositionUseCase(driverPositionRepository),
    deleteDriverPosition: DeleteDriverPositionUseCase(driverPositionRepository),
    getDriverPosition: GetDriverPositionUseCase(driverPositionRepository),
  );


  // Driver Trip Request Repository
  @injectable
  DriverTripRequestsRepository get driverTripRequestsRepository => DriverTripRequestsRepositoryImpl(driverTripRequestsService);
 
  @injectable
  DriverTripRequestsUseCases get driverTripRequestsUseCases => DriverTripRequestsUseCases(
    createTripRequestUseCase: CreateTripRequestUseCase(driverTripRequestsRepository),
    getTimeAndDistance: GetTimeAndDistanceUseCase(driverTripRequestsRepository),
    getTripDetailUseCase: GetTripDetailUseCase(driverTripRequestsRepository),
    getDriverTripsUseCase: GetDriverTripsUseCase(driverTripRequestsRepository),
    getAllTripsUseCase: GetAllTripsUseCase(driverTripRequestsRepository)
  );


  // Passenger Request Repository
  @injectable
  PassengerRequestRepository get passengerRequestRepository => PassengerRequestRepositoryImpl(passengerRequestsService);
 
  @injectable
  PassengerRequestsUseCases get passengerRequestsUseCases => PassengerRequestsUseCases(
    getNearbyTripRequestUseCase: GetNearbyTripRequestUseCase(passengerRequestRepository)
  );


  // Reserve Repository
  @injectable
  ReserveRepository get reserveRepository => ReserveRepositoryImpl(reserveService);
 
  @injectable
  ReserveUseCases get reserveUseCases => ReserveUseCases(
    createReserve: CreateReserveUseCase(reserveRepository),
    getReserveDetailUseCase: GetReserveDetailUseCase(reserveRepository),
    getAllReservesUseCase: GetAllReservesUseCase(reserveRepository)
  );


  // Socket Repository
  @injectable
  SocketRepository get socketRepository => SocketRepositoryImpl(socket);
  
  @injectable
  SocketUseCases get socketUseCases => SocketUseCases(
    connect: ConnectSocketUseCase(socketRepository),
    disconnect: DisconnectSocketUseCase(socketRepository),
  );
}
