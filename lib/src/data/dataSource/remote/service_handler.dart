import 'dart:io';
import 'package:carpool_21_app/src/data/api/apiConfig.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/authService.dart';
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class ServiceHandler {
  final Dio _dio;
  late CacheOptions _cacheOptions;
  late AuthUseCases _authUseCases;
  late AuthService _authService;
  
  // Singleton ServiceHandler
  // Uso el patron Singleton que me da acceso a authUseCases y authService sin tener que pasarlo en todas las llamadas 
  static final ServiceHandler _instance = ServiceHandler._internal();

  factory ServiceHandler() {
    return _instance;
  }

  ServiceHandler._internal(): _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.API_CARPOOL21,
    contentType: 'application/json',
  )) {
    _initializeCacheOptions();
  }

  // Cache configuration
  Future<void> _initializeCacheOptions() async {
    _cacheOptions = CacheOptions(
      store: await _getCacheStore(),
      policy: CachePolicy.noCache,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(hours: 5),
    );
    _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));
  }

  // Define Cache Sotrage
  Future<HiveCacheStore> _getCacheStore() async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/cache_store';
    return HiveCacheStore(path);
  }

  // Clear cache
  Future<bool> clearCacheByKey(String key) async {
    final cacheStore = await _getCacheStore();
    await cacheStore.delete(key);
    return true;
  }

  // Configure functions
  void configure(AuthUseCases authUseCases, AuthService authService) {
    _authUseCases = authUseCases;
    _authService = authService;
  }

  // Request function >>>>>>>>>>>>>>>>>>>>
  Future<Response> request(
    String method, 
    String path, 
    int maxAge, 
    int maxStale, 
    {
      Map<String, dynamic>? data,
      Map<String, dynamic>? body,
      bool? refresh
    }
  ) async {
    // Esperamos que la cache se inicialize
    await _initializeCacheOptions();

    // Definimos Modelo de Request
    Future<Response> doRequest(token) {
      return _dio.request(
        path, // Ruta
        options: Options(
          method: method, // Metodo GET - POST - PATCH - PUT - DELETE
          headers: {"Authorization": "Bearer $token"},
          extra: {
            'cacheOptions': _cacheOptions.copyWith(
              policy: refresh == true ? CachePolicy.noCache : CachePolicy.request,
              maxStale: Nullable(Duration(hours: maxStale)),
            ),
          },
        ),
        data: body, // Cuerpo de la petición
        queryParameters: {...?data}, // Parametros de la petición
      );
    }

    // Hacemos la peticion y manejamos errores
    try {
      dynamic tokenData = await _authUseCases.getUserTokenUseCase.run();
      print('Success token: $tokenData');
      // print(tokenData['token']);

      // PROBAR REFRESH TOKEN, pasar mal el token me devuelve 401
      dynamic res = await doRequest(tokenData['token']);
      return res;
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw ConnectionError();
      }

      // Token vencido - Intentamos regenerarlo
      if (e.response?.statusCode == 401) {
        print('Error Message: ${e.message}');
        print('Error Response Message: ${e.response?.statusMessage}');

        dynamic tokenData = await _authUseCases.getUserTokenUseCase.run();
        print('DioExeption token: $tokenData');
        

        // DESCOMENTAR TODO ESTO CUANDO TENGA EL REFRESH TOKEN
        // dynamic newTokenRes = await _authService.getTokenFromRefresh(tokenData['refreshToken']);

        // if (newTokenRes is Error) {
          throw TokenError();
        // }

        // AuthResponse authResponse = (newTokenRes as Success<AuthResponse>).data;
        
        // // Actualizando Token y refreshToken
        // await _authUseCases.saveUserTokenUseCase.run(authResponse);

        // dynamic res = await doRequest(authResponse.token);
        // return res;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}