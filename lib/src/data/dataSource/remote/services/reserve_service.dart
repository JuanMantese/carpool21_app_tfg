// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/reserve_request.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class ReserveService {

  ServiceHandler serviceHandler;
  Future<String> token;

  // Constructor
  ReserveService(this.serviceHandler, this.token);

  // Creando la reserva
  Future<Resource<ReserveDetail>> create(ReserveRequest reserveRequest) async {
    try {
      // Construimos la ruta para la creación de la reserva
      String path = '/trip-reservation/reserve-seat';
      
      // Creamos el cuerpo de la solicitud con los datos de la reserva
      Map<String, dynamic> body = reserveRequest.toJson();

      // Hacemos la petición con el método POST a la ruta construida
      Response response = await serviceHandler.request(
        "POST", 
        path, 
        1, 
        168,
        body: body, // Enviamos el cuerpo de la solicitud
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        ReserveDetail reserveDetail = ReserveDetail.fromJson(response.data);
        print('Data createReserve: ${reserveDetail.toJson()}');
        return Success(reserveDetail);
      } else {
        print('ERROR createReserve Service --------------------------------');
        print('status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
      print('CreateReserve Service Error');
      if (e is TokenError) {
        // Maneja el error del token, por ejemplo, redirigiendo al usuario al login
        print(e.message);
        return ErrorData(e.message);
      } else if (e is DioException) {
        // Maneja los errores específicos de Dio
        print('Dio error: ${e.message}');
        return ErrorData('Dio error: ${e.message}');
      } else if (e is ConnectionError) {
        // Maneja los errores de conexión
        print('Connection error: ${e.message}');
        return ErrorData('Connection error: ${e.message}');
      } else {
        // Maneja otros tipos de errores
        print('Unhandled error: $e');
        return ErrorData('Unhandled error: $e');
      }
    }
  }

  // Consultando el detalle de una reserva
  Future<Resource<ReserveDetail>> getReserveDetail(int idReserve) async {
    try {
      // Construimos la ruta para obtener el detalle de la reserva
      String path = '/trip-reservation/findOne/$idReserve';
      
      // Hacemos la petición con el método GET a la ruta construida
      Response response = await serviceHandler.request(
        "GET", 
        path, 
        1, 
        168,
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        ReserveDetail reserveDetail = ReserveDetail.fromJson(response.data);
        print('Data getReserveDetail: ${reserveDetail.toJson()}');
        return Success(reserveDetail);
      } else {
        print('ERROR getReserveDetail Service --------------------------------');
        print('status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
      print('GetReserveDetail Service Error');
      if (e is TokenError) {
        // Maneja el error del token, por ejemplo, redirigiendo al usuario al login
        print(e.message);
        return ErrorData(e.message);
      } else if (e is DioException) {
        // Maneja los errores específicos de Dio
        print('Dio error: ${e.message}');
        return ErrorData('Dio error: ${e.message}');
      } else if (e is ConnectionError) {
        // Maneja los errores de conexión
        print('Connection error: ${e.message}');
        return ErrorData('Connection error: ${e.message}');
      } else {
        // Maneja otros tipos de errores
        print('Unhandled error: $e');
        return ErrorData('Unhandled error: $e');
      }
    }
  }

  // Consultando todas las reservas de un usuario
  Future<Resource<ReservesAll>> getMyReservesAll() async {
    try {
      Response myReservesAllRes = await serviceHandler.request(
        "GET", 
        "/trip-reservation/findAllByUser", 
        1, 
        168,
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (myReservesAllRes.statusCode == 200 || myReservesAllRes.statusCode == 201) {
        ReservesAll reservesAll = ReservesAll.fromJson(myReservesAllRes.data);
        print('Data getReservesAll: ${reservesAll.toJson()}');
        return Success(reservesAll);
      } else {
        print('ERROR getMyReservesAll Service --------------------------------');
        print('status: ${myReservesAllRes.statusCode}');
        print('Response body: ${myReservesAllRes.data}');
        return ErrorData(myReservesAllRes.data['message']);
      }
    } catch (e) {
      print('GetMyReservesAll Service Error');
      if (e is TokenError) {
        // Maneja el error del token, por ejemplo, redirigiendo al usuario al login
        print(e.message);
        return ErrorData(e.message);
      } else if (e is DioException) {
        // Maneja los errores específicos de Dio
        print('Dio error: ${e.message}');
        return ErrorData('Dio error: ${e.message}');
      } else if (e is ConnectionError) {
        // Maneja los errores de conexión
        print('Connection error: ${e.message}');
        return ErrorData('Connection error: ${e.message}');
      } else {
        // Maneja otros tipos de errores
        print('Unhandled error: $e');
        return ErrorData('Unhandled error: $e');
      }
    }
  }

  // Consultando el detalle de una reserva
  Future<Resource<ReserveDetail>> cancelReserve(int idReserve) async {
    try {
      // Construimos la ruta para obtener el detalle de la reserva
      String path = '/trip-reservation/cancel/$idReserve';
      
      // Hacemos la petición con el método GET a la ruta construida
      Response response = await serviceHandler.request(
        "DELETE", 
        path, 
        1, 
        168,
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        ReserveDetail cancelResDetail = ReserveDetail.fromJson(response.data);
        print('Data cancelReserve: ${cancelResDetail.toJson()}');
        return Success(cancelResDetail);
      } else {
        print('ERROR cancelReserve Service --------------------------------');
        print('status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
      print('CancelReserve Service Error');
      if (e is TokenError) {
        // Maneja el error del token, por ejemplo, redirigiendo al usuario al login
        print(e.message);
        return ErrorData(e.message);
      } else if (e is DioException) {
        // Maneja los errores específicos de Dio
        print('Dio error: ${e.message}');
        return ErrorData('Dio error: ${e.message}');
      } else if (e is ConnectionError) {
        // Maneja los errores de conexión
        print('Connection error: ${e.message}');
        return ErrorData('Connection error: ${e.message}');
      } else {
        // Maneja otros tipos de errores
        print('Unhandled error: $e');
        return ErrorData('Unhandled error: $e');
      }
    }
  }
}