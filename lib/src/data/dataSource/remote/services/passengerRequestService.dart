import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class PassengerRequestsService {

  ServiceHandler serviceHandler;
  Future<String> token;

  PassengerRequestsService(this.serviceHandler, this.token);

  // Consultando todos los viajes disponibles - getNearbyTripRequest: Consultando viajes cercanos
  // Future<Resource<List<TripDetail>>> getNearbyTripRequest(double driverLat, double driverLng) async {

  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/passenger-requests/${driverLat}/${driverLng}');

  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     }; // We specify that the information sent is of type JSON

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Devuelve una lista con todos los viajes cercanos
  //       List<TripDetail> passengerRequests = TripDetail.fromJsonList(data); 
  //       return Success(passengerRequests);
  //     } else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return ErrorData(e.toString());
  //   }
  // }

  Future<Resource<List<TripDetail>>> getNearbyTripRequest(double driverLat, double driverLng) async {
    try {
      // Construimos la ruta para obtener los viajes cercanos
      String path = '/passenger-requests/$driverLat/$driverLng';
      
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
        // Devuelve una lista con todos los viajes cercanos
        List<TripDetail> passengerRequests = (response.data as List)
            .map((trip) => TripDetail.fromJson(trip))
            .toList();
        return Success(passengerRequests);
      } else {
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


}