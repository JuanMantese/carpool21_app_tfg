
import 'package:carpool_21_app/src/data/api/apiConfig.dart';
import 'package:carpool_21_app/src/data/dataSource/local/sharedPref.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/authService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/carInfoService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/driverTripRequestsService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/driversPositionService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/passengerRequestService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/reserveService.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/data/repository/authRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/carInfoRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/driverPositionRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/driverTripRequestsRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/geolocationRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/passengerRequestRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/reserveRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/socketRepositoryImpl.dart';
import 'package:carpool_21_app/src/data/repository/usersRepositoryImpl.dart';
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';
import 'package:carpool_21_app/src/domain/repository/carInfoRepository.dart';
import 'package:carpool_21_app/src/domain/repository/driverPositionRepository.dart';
import 'package:carpool_21_app/src/domain/repository/driverTripRequestsRepository.dart';
import 'package:carpool_21_app/src/domain/repository/geolocationRepository.dart';
import 'package:carpool_21_app/src/domain/repository/passengerRequestRepository.dart';
import 'package:carpool_21_app/src/domain/repository/reserveRepository.dart';
import 'package:carpool_21_app/src/domain/repository/socketRepository.dart';
import 'package:carpool_21_app/src/domain/repository/usersRepository.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/changeRolUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/getUserSessionUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/getUserTokenUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/loginUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/logoutUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/registerUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/saveUserSessionUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/saveUserTokenUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/updateUserSessionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/createCarInfoUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/getCarInfoUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/getCarListUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/updateCarInfoUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/createTripRequestUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getAllTripsUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getDriverTripsUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getTimeAndDistanceUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/getTripDetailUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/createDriverPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/deleteDriverPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/driversPositionUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/getDriverPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/createMarkerUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/findPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocationUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getLocationDataUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getMarkerUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPlacemarkDataUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPolylineUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPositionStreamUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/passenger-request/getNerbyTripRequestUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/passenger-request/passengerRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/createReserveUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/getAllReservesUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/getReserveDetailUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/reserves/reserveUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/connectSocketUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/disconnectSocketUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socketUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/users/getUserDetailUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/users/updateUserUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/users/userUseCases.dart';
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
    baseUrl: 'http://192.168.100.154:3000',
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
  Socket get socket => io('http://${ApiConfig.API_CARPOOL21}', 
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
