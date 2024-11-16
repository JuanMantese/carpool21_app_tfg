
import 'dart:convert';
import 'dart:math';

import 'package:carpool_21_app/src/data/dataSource/local/sharedPref.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/authService.dart';
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/repository/authRepository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

// Implementation of AuthRepository methods
class AuthRepositoryImpl implements AuthRepository {

  // Instantiating the dependency
  AuthService authService; // Remote Storage
  SharedPref sharedPref; // Local Storage

  // Initializing the dependency in the constructor
  AuthRepositoryImpl(
    this.authService,
    this.sharedPref,
  );

  // implementation login
  @override
  Future<Resource<AuthResponse>> login(String email, String password) {
    return authService.login(email, password);
  }

  // implementation user register
  @override
  Future<Resource<AuthResponse>> register(User user) {
    return authService.register(user);
  }

  // implementation user register
  @override
  Future<Resource<User>> changeRol(String idRole) {
    return authService.changeRol(idRole);
  }

  // implementation logout
  @override
  Future<bool> logout() async {
    return await sharedPref.remove('user');
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    sharedPref.save('user', authResponse.toJson());
  }

  @override
  Future<void> updateUserSession(User userData) async {
    AuthResponse? authResponse = await getUserSession();

    if (authResponse != null) {
      authResponse.user = userData;
      await sharedPref.save('user', authResponse.toJson());
    }
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharedPref.read('user');
    if (data != null) {
      // We interpret the data that comes in JSON format
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<void> saveUserToken(AuthResponse authResponse) async {
    String tokenJson = json.encode({"token": authResponse.token});
    String refreshTokenJson = json.encode({"refreshToken": authResponse.refreshToken});

    sharedPref.saveToken(tokenJson, refreshTokenJson);
  }

  @override
  Future<Map<String, String>?> getUserToken() async {
    final dataToken = await sharedPref.readToken();
    // print(dataToken);
    // print(dataToken[0]);
    // print(dataToken[1]);
    if (dataToken.isNotEmpty && dataToken[0] != null && dataToken[1] != null) {
      // Decoding the JSON formatted token and expiration date
      try {
        Map<String, dynamic> tokenMap = json.decode(dataToken[0]!);
        Map<String, dynamic> refreshTokenMap = json.decode(dataToken[1]!);

        // Extract the token and token expiration from the map
        String token = tokenMap['token'];
        String refreshToken = refreshTokenMap['refreshToken'];

        Map<String, String> tokenData = {
          'token': token,
          'refreshToken': refreshToken,
        };

        return tokenData;        
      } catch (e) {
        print('Error: las cadenas JSON no contienen los campos esperados');
      }

    }
    return null;
  }
}