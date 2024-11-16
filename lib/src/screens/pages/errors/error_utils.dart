import 'package:carpool_21_app/src/screens/utils/globals.dart';
import 'package:flutter/material.dart';

Map<int, String> statusCodeMessage = {
  // Bad request
  400: code400,
  // Payment required
  401: code401,
  // Unauthorized
  402: code402,
  // Forbidden
  403: code403,
  // Not found
  404: code404,
  // Method not allowed
  405: code405,
  // Not Acceptable
  406: code406,
  // Proxy Authentication Required
  407: code407,
  // Request Timeout
  408: code408,
  // Conflict
  409: code409,
  // Gone
  410: code410,
  // Length Required
  411: code411,
  // Precondition Failed
  412: code412,
  // Too Many Requests
  429: code429,
  // Internal Server Error
  500: code500,
  // Not implemented
  501: code501,
  // Bad Gateway
  502: code502,
  // Service Unavailable
  503: code503,
  // Gateway Timeout
  504: code504,
  // Network Authentication Required
  511: code511,
};

// custom errors
class ConnectionError extends Error {
  final String message;
  ConnectionError({this.message = "¡No hay internet!"});
}

class TokenError extends Error {
  final String message;
  TokenError({this.message = "Se cerró tu sesión."});
}

class ErrorImage {
  /// lib/assets/img/error-no-conexion-server.png
  static const AssetImage connectionErrorServer =
      AssetImage("lib/assets/img/error-no-conexion-server.png");

  /// lib/assets/img/error-internal-server.png
  static const AssetImage internalServerError =
      AssetImage("lib/assets/img/error-internal-server.png");

  /// lib/assets/img/error-no-connection-client.png
  static const AssetImage connectionErrorClient =
      AssetImage("lib/assets/img/error-no-connection-client.png");

  /// lib/assets/img/error-no-user.png
  static const AssetImage userNotFound =
      AssetImage("lib/assets/img/error-no-user.png");

  /// lib/assets/img/error-not-found.png
  static const AssetImage notFound =
      AssetImage("lib/assets/img/error-not-found.png");

  /// lib/assets/img/error-time-out.png
  static const AssetImage errorTimeOut =
      AssetImage("lib/assets/img/error-time-out.png");

  /// lib/assets/img/error-unauthorized.png
  static const AssetImage unauthorized =
      AssetImage("lib/assets/img/error-unauthorized.png");
}