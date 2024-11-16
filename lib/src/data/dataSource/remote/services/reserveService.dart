import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';


class ReserveService {

  ServiceHandler serviceHandler;
  Future<String> token;

  // Constructor
  ReserveService(this.serviceHandler, this.token);

  // Future<Resource<ReserveDetail>> create(ReserveRequest reserveRequest) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-reservation/reserve-seat');
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };
  //     print(await token);
  //     String body = json.encode(reserveRequest.toJson());

  //     final response = await http.post(url, headers: headers, body: body);
  //     final data = json.decode(response.body);
  //     print('Aca en el service');
      
  //     print(response);
  //     print(data);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       ReserveDetail reserveDetail = ReserveDetail.fromJson(data);
  //       return Success(reserveDetail);
  //     } else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error CreateReserve: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

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
        print('Response status createReserve: ${response.statusCode}');
        print('Response body createReserve: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
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

  // Trayendo el vehiculo del conductor
  // Future<Resource<ReserveDetail>> getReserveDetail(int idReserve) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-reservation/findOne/$idReserve');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);

  //     print(response);
  //     print('Data: $data');
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       ReserveDetail reserveDetail = ReserveDetail.fromJson(data);
  //       return Success(reserveDetail);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error GetReserveDetail Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

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
        print('Response status getReserveDetail: ${response.statusCode}');
        print('Response body getReserveDetail: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
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

  // Trayendo todas las reservas de un pasajero
  // Future<Resource<ReservesAll>> getMyReservesAll() async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-reservation/my-reservations');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       ReservesAll reservesAll = ReservesAll.fromJson(data);
  //       return Success(reservesAll);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error GetReservesAll Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<ReservesAll>> getMyReservesAll() async {
    try {
      Response myReservesAllRes = await serviceHandler.request("GET", "/trip-reservation/my-reservations", 1, 168,);

      ReservesAll reservesAll = ReservesAll.fromJson(myReservesAllRes.data);
      return Success(reservesAll);
    } catch (e) {
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