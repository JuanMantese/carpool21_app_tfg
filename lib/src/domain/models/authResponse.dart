import 'dart:convert';

import 'package:carpool_21_app/src/domain/models/user.dart';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  User? user;
  String token;
  String refreshToken;

  AuthResponse({
    this.user,
    required this.token,
    required this.refreshToken
  });

  // Receives a json object and transforms it into a dynamic object
  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: User.fromJson(json["user"]),
    token: json["token"],
    refreshToken: json?["refreshToken"] != null ? json["refreshToken"] : '',
  );

  // Allows access to all User information and the Session Token
  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "refreshToken": refreshToken,
  };
}