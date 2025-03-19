// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/list_to_string.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:dio/dio.dart';

class AuthService {

  final Dio _dio;
  Future<String> token;

  // Constructor
  AuthService(this._dio, this.token);

  // Login Service
  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', 
        data: {
          'email': email,
          'password': password,
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        // print('Token: ${authResponse.token}');
        // print('RefreshToken: ${authResponse.refreshToken}');
        
        return Success(authResponse);
      } else {
        return ErrorData(listToString(response.data['message']));
      }
    } on DioException catch (e) {
      // Manejo de errores específicos de Dio
      print('Error login service: $e');
      // Verificar si 'message' es una lista en el error de la respuesta
      final message = e.response!.data['message'];
      
      if (message is List) {
        return ErrorData(message.join(', '));  // Convertimos la lista en un String
      } else {
        return ErrorData(message ?? e.message);  // Si no es lista, usamos el mensaje original
      }
    } catch (error) {
      print('Error login service: $error');
      return ErrorData(error.toString());
    }
  }

  /// Get a new auth token from an active refresh token
  Future<Resource<AuthResponse>> getTokenFromRefresh(String refreshToken) async {
    try {
      final response = await _dio.get('/auth/refresh',
        queryParameters: {
          'refresh_token': refreshToken,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['token'] as String;
        final newRefreshToken = data['refreshToken'] as String;
        
        AuthResponse authResponse = AuthResponse(
          token: accessToken,
          refreshToken: newRefreshToken,
        );

        return Success(authResponse);
      } else {
        return ErrorData(listToString(response.data['message']));
      }
    } on DioException catch (e) {
      // Manejo de errores específicos de Dio
      print('Error refresh token service: $e');
      if (e.response != null) {
        return ErrorData(e.response!.data['message'] ?? e.message);
      } else {
        return ErrorData(e.message!);
      }
    } catch (error) {
      print('Error refresh token service: $error');
      return ErrorData(error.toString());
    }
  }

  // Register New User Service
  Future<Resource<AuthResponse>> register(User user) async {
    try {
      final response = await _dio.post('/auth/register', 
        data: user.toJson()
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data Remote: ${authResponse.toJson()}');
        // print('Token: ${authResponse.token}');
        // print('RefreshToken: ${authResponse.refreshToken}');
        
        return Success(authResponse);
      } else {
        return ErrorData(listToString(response.data['message']));
      }
    } on DioException catch (e) {
      // Manejo de errores específicos de Dio
      print('Error register service: $e');
      // Verificar si 'message' es una lista en el error de la respuesta
      final message = e.response!.data['message'];
      
      if (message is List) {
        return ErrorData(message.join(', '));  // Convertimos la lista en un String
      } else {
        return ErrorData(message ?? e.message);  // Si no es lista, usamos el mensaje original
      }
    } catch (error) {
      print('Error register service: $error');
      return ErrorData(error.toString());
    }
  } 

}