
// Using local storage to save data
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _keyToken = 'token';
  static const String _keyTokenExpiration = 'token_expiration';

  // Saving data - Key: Key value to save
  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Storing a value in json format
    prefs.setString(key, json.encode(value));
  }

  // Reading session information
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) != null) {
      return json.decode(prefs.getString(key)!);
    }
    return null;
  }

  // Removing session information
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  // Allows you to know if any element exists within the session
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Saving token and expiration date
  Future<void> saveToken(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_keyToken, json.encode(token)); // Storing the token
    await prefs.setString(_keyTokenExpiration, json.encode(refreshToken)); // Storing the expiration date
  }

  // Reading token
  Future<List<String?>> readToken() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String?> authTokenData = <String?>[];
    authTokenData.add(json.decode(prefs.getString(_keyToken)!));
    authTokenData.add(json.decode(prefs.getString(_keyTokenExpiration)!));
    return authTokenData;
  }

  // Reading token expiration date
  // Future<DateTime?> readTokenExpiration() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final expirationDateString = prefs.getString('token_expiration');
  //   if (expirationDateString != null) {
  //     return DateTime.parse(expirationDateString);
  //   }
  //   return null;
  // }

}