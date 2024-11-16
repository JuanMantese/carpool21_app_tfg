import 'dart:convert';

import 'package:carpool_21_app/src/data/api/apiConfig.dart';
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/listToString.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthService {

  final Dio _dio;
  Future<String> token;

  // Constructor
  AuthService(this._dio, this.token);

  // Future<Resource<AuthResponse>> login(String email, String password) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/auth/login'); // Creation of the URL path
      
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json'
  //     }; // We specify that the information sent is of type JSON
      
  //     String body = json.encode({
  //       'email': email,
  //       'password': password
  //     });

  //     // Making the request. I specify the URL, the headers and the body
  //     final response = await http.post(url, headers: headers, body: body);

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       AuthResponse authResponse = AuthResponse.fromJson(data);
  //       print('Data Remote: ${authResponse.toJson()}');
  //       print('Token: ${authResponse.token}');

  //       return Success(authResponse);
  //     } else {
  //       print('Response status login: ${response.statusCode}');
  //       print('Response body login: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error login service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

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
      if (e.response != null) {
        return ErrorData(e.response!.data['message'] ?? e.message);
      } else {
        return ErrorData(e.message!);
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

  Future<Resource<AuthResponse>> register(User user) async {
    try {
      Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/auth/register'); // Creation of the URL path
      Map<String, String> headers = {'Content-Type': 'application/json'}; // We specify that the information sent is of type JSON
      String body = json.encode(user);

      // Making the request. I specify the URL, the headers and the body
      final response = await http.post(url, headers: headers, body: body);

      // Decoding the information to be able to interpret it in Dart
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        print('Data register: ${authResponse.toJson()}');
        print('Token register: ${authResponse.token}');

        return Success(authResponse);
      } else {
        print('Response status register: ${response.statusCode}');
        print('Response body register: ${response.body}');
        return ErrorData(listToString(data['message']));
      }
    } catch (error) {
      print('Error register service: $error');
      return ErrorData(error.toString());
    }
  }

  // Future<Resource<User>> changeRol(String idRole) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/users/change-role'); // Creation of the URL path
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     }; // We specify that the information sent is of type JSON

  //     String body = json.encode(
  //       {'idRole': idRole}
  //     );

  //     // Making the request. I specify the URL, the headers and the body
  //     final response = await http.patch(url, headers: headers, body: body);

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       User userResponse = User.fromJson(data);
  //       print('Data changeRol: ${userResponse.toJson()}');

  //       return Success(userResponse);
  //     } else {
  //       print('Response status changeRol: ${response.statusCode}');
  //       print('Response body changeRol: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error changeRol Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<User>> changeRol(String idRole) async {
    try {
      final response = await _dio.patch(
        '/users/change-role',
        data: jsonEncode({'idRole': idRole}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await token}',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(response.data);
        print('Data changeRol: ${userResponse.toJson()}');
        return Success(userResponse);
      } else {
        print('Response status changeRol: ${response.statusCode}');
        print('Response body changeRol: ${response.data}');
        return ErrorData(listToString(response.data['message']));
      }
    } catch (e) {
      if (e is TokenError) {
        print(e.message);
        return ErrorData(e.message);
      } else if (e is DioException) {
        print('Dio error: ${e.message}');
        return ErrorData('Dio error: ${e.message}');
      } else if (e is ConnectionError) {
        print('Connection error: ${e.message}');
        return ErrorData('Connection error: ${e.message}');
      } else {
        print('Unhandled error: $e');
        return ErrorData('Unhandled error: $e');
      }
    }
  }

}