// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:carpool_21_app/src/data/dataSource/local/sharedPref.dart'
    as _i3;
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart'
    as _i5;
import 'package:carpool_21_app/src/data/dataSource/remote/services/auth_service.dart'
    as _i6;
import 'package:carpool_21_app/src/data/dataSource/remote/services/car_info_service.dart'
    as _i8;
import 'package:carpool_21_app/src/data/dataSource/remote/services/driver_trip_requests_service.dart'
    as _i10;
import 'package:carpool_21_app/src/data/dataSource/remote/services/driversPositionService.dart'
    as _i9;
import 'package:carpool_21_app/src/data/dataSource/remote/services/passenger_request_service.dart'
    as _i11;
import 'package:carpool_21_app/src/data/dataSource/remote/services/reserve_service.dart'
    as _i12;
import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart'
    as _i7;
import 'package:carpool_21_app/src/di/appModule.dart' as _i32;
import 'package:carpool_21_app/src/domain/repository/auth_repository.dart'
    as _i14;
import 'package:carpool_21_app/src/domain/repository/car_info_repository.dart'
    as _i20;
import 'package:carpool_21_app/src/domain/repository/driver_position_repository.dart'
    as _i22;
import 'package:carpool_21_app/src/domain/repository/driver_trip_requests_repository.dart'
    as _i24;
import 'package:carpool_21_app/src/domain/repository/geolocation_repository.dart'
    as _i18;
import 'package:carpool_21_app/src/domain/repository/passenger_request_repository.dart'
    as _i26;
import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart'
    as _i28;
import 'package:carpool_21_app/src/domain/repository/socket_repository.dart'
    as _i30;
import 'package:carpool_21_app/src/domain/repository/users_repository.dart'
    as _i16;
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart'
    as _i15;
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart'
    as _i21;
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart'
    as _i25;
import 'package:carpool_21_app/src/domain/useCases/drivers-position/drivers_position_use_cases.dart'
    as _i23;
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart'
    as _i19;
import 'package:carpool_21_app/src/domain/useCases/passenger-request/passenger_request_use_cases.dart'
    as _i27;
import 'package:carpool_21_app/src/domain/useCases/reserves/reserve_use_cases.dart'
    as _i29;
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart'
    as _i31;
import 'package:carpool_21_app/src/domain/useCases/users/user_use_cases.dart'
    as _i17;
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:socket_io_client/socket_io_client.dart' as _i13;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.SharedPref>(() => appModule.sharedPref);
    gh.factory<_i4.Dio>(() => appModule.dio);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i5.ServiceHandler>(() => appModule.serviceHandler);
    gh.factory<_i6.AuthService>(() => appModule.authService);
    gh.factory<_i7.UsersService>(() => appModule.usersService);
    gh.factory<_i8.CarInfoService>(() => appModule.carInfoService);
    gh.factory<_i9.DriversPositionService>(
        () => appModule.driversPositionService);
    gh.factory<_i10.DriverTripRequestsService>(
        () => appModule.driverTripRequestsService);
    gh.factory<_i11.PassengerRequestsService>(
        () => appModule.passengerRequestsService);
    gh.factory<_i12.ReserveService>(() => appModule.reserveService);
    gh.factory<_i13.Socket>(() => appModule.socket);
    gh.factory<_i14.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i15.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i16.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i17.UserUseCases>(() => appModule.userUseCases);
    gh.factory<_i18.GeolocationRepository>(
        () => appModule.geolocationRepository);
    gh.factory<_i19.GeolocationUseCases>(() => appModule.geolocationUseCases);
    gh.factory<_i20.CarInfoRepository>(() => appModule.carInfoRepository);
    gh.factory<_i21.CarInfoUseCases>(() => appModule.carInfoUseCases);
    gh.factory<_i22.DriverPositionRepository>(
        () => appModule.driverPositionRepository);
    gh.factory<_i23.DriversPositionUseCases>(
        () => appModule.driversPositionUseCases);
    gh.factory<_i24.DriverTripRequestsRepository>(
        () => appModule.driverTripRequestsRepository);
    gh.factory<_i25.DriverTripRequestsUseCases>(
        () => appModule.driverTripRequestsUseCases);
    gh.factory<_i26.PassengerRequestRepository>(
        () => appModule.passengerRequestRepository);
    gh.factory<_i27.PassengerRequestsUseCases>(
        () => appModule.passengerRequestsUseCases);
    gh.factory<_i28.ReserveRepository>(() => appModule.reserveRepository);
    gh.factory<_i29.ReserveUseCases>(() => appModule.reserveUseCases);
    gh.factory<_i30.SocketRepository>(() => appModule.socketRepository);
    gh.factory<_i31.SocketUseCases>(() => appModule.socketUseCases);
    return this;
  }
}

class _$AppModule extends _i32.AppModule {}
