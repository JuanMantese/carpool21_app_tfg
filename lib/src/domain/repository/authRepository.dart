
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

// We define the business logic
abstract class AuthRepository {
  Future<Resource<AuthResponse>> login(String email, String password);
  Future<Resource<AuthResponse>> register(User user);
  Future<Resource<User>> changeRol(String idRole);
  Future<bool> logout();

  // Save user session in local storage
  Future<void> saveUserSession(AuthResponse authResponse);

  // Update user session in local storage
  Future<void> updateUserSession(User userData);

  // Obtaining user session from local storage
  Future<AuthResponse?> getUserSession();

  // Save user token and token expiration in local storage
  Future<void> saveUserToken(AuthResponse authResponse);

  // Obtaining user token and token expiration of local storage
  Future<void> getUserToken();
}