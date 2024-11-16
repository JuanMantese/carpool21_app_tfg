
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/screens/pages/errors/errorPage.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

StatelessWidget Function(dynamic, StackTrace?) requestErrorHandler({
  required dynamic ref,
  void Function()? retryEndpoint,
  String? retryEndpointByName,
  dynamic retryProvider,
  bool? compact,
  BuildContext? context,
}) {
  return (dynamic error, StackTrace? stackTrace) {
    if (error is DioException) {
      final dioError = error;
      void Function()? retryByName;

      if (retryEndpointByName != null && retryProvider != null) {
        retryByName = () {
          ref.refresh(retryProvider);
          // ServiceHandler().clearCacheByKey(retryEndpointByName);
        };
      }

      return ErrorScreen(
        compact: compact,
        message: getMessageFromStatusCode(dioError.response?.statusCode),
        errorImage: getImageFromStatusCode(dioError.response?.statusCode.toString()),
        retryOverride: retryByName ?? retryEndpoint,
        subtitle: getSubtitleFromStatusCode(dioError.response?.statusCode.toString()),
      );

    } else if (error is ConnectionError) {
      void Function()? retryByName;
      if (retryEndpointByName != null && retryProvider != null) {
        retryByName = () {
          ref.refresh(retryProvider);
          // ServiceHandler().clearCacheByKey(retryEndpointByName);
        };
      }

      return ErrorScreen(
        compact: compact,
        message: ConnectionError().message,
        retryOverride: retryByName ?? retryEndpoint,
        errorImage: ErrorImage.connectionErrorClient,
        subtitle: "Por favor revisá tu conexión para poder continuar.",
      );

    } else if (error is TokenError) {
      if (context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return ErrorScreen(
                message: TokenError().message,
                errorImage: ErrorImage.userNotFound,
                button: "Aceptar",
                subtitle: "Pasó mucho tiempo desde tu última visita, o iniciaste sesión en otro dispositivo.\nPor favor volvé a ingresar tus datos.",
              );
            },
          ));
        });
        return Container();

      } else {
        return ErrorScreen(
          compact: compact,
          message: TokenError().message,
          errorImage: ErrorImage.userNotFound,
          button: "Aceptar",
          subtitle: "Pasó mucho tiempo desde tu última visita, o iniciaste sesión en otro dispositivo.\nPor favor volvé a ingresar tus datos.",
        );
      }
    } else {
      return ErrorScreen(
        compact: compact,
        message: "Ocurrió un error.",
      );
    }
  };
}

AssetImage getImageFromStatusCode(String? code) {
  final serverError = RegExp("503");
  final internalServerError = RegExp("5..");
  final unauthorized = RegExp("403");
  final userNotFound = RegExp("401|407|511");
  final timeOut = RegExp("408");
  final clientError = RegExp("4..");
  if (code == null) {
    return ErrorImage.connectionErrorServer;
  } else if (userNotFound.hasMatch(code)) {
    return ErrorImage.userNotFound;
  } else if (serverError.hasMatch(code)) {
    return ErrorImage.connectionErrorServer;
  } else if (internalServerError.hasMatch(code)) {
    return ErrorImage.internalServerError;
  } else if (unauthorized.hasMatch(code)) {
    return ErrorImage.unauthorized;
  } else if (timeOut.hasMatch(code)) {
    return ErrorImage.errorTimeOut;
  } else if (clientError.hasMatch(code)) {
    return ErrorImage.notFound;
  } else {
    return ErrorImage.internalServerError;
  }
}


String getSubtitleFromStatusCode(String? code) {
  final serverError = RegExp("503");
  final internalServerError = RegExp("5..");
  final unauthorized = RegExp("403");
  final userNotFound = RegExp("401|407|511");
  final timeOut = RegExp("408");
  final clientError = RegExp("4..");
  if (code == null) {
    return "Estamos trabajando para solucionarlo.\nPor favor volvé a intentar más tarde.";
  } else if (userNotFound.hasMatch(code)) {
    return "Por favor volvé a ingresar tus datos.";
  } else if (serverError.hasMatch(code)) {
    return "Por favor volvé a intentarlo más tarde.";
  } else if (internalServerError.hasMatch(code)) {
    return "Estamos trabajando para solucionarlo.\nPor favor volvé a intentar más tarde.";
  } else if (unauthorized.hasMatch(code)) {
    return "Por favor intentá con otras credenciales.";
  } else if (timeOut.hasMatch(code)) {
    return "Este proceso puede demorar algunos minutos. Gracias por esperar.";
  } else if (clientError.hasMatch(code)) {
    return "Por favor intentá con otras credenciales.";
  } else {
    return "Estás intentando acceder a una página que no existe o no está disponible.\nPor favor probá regresar a la página anterior.";
  }
}