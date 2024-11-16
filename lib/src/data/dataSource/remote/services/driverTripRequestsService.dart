import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/driverTripRequest.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/models/tripsAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class DriverTripRequestsService {

  ServiceHandler serviceHandler;
  Future<String> token;

  DriverTripRequestsService(this.serviceHandler, this.token);

  // Consultamos al Back cual es el Tiempo estimado del viaje y su Distancia del origen al destino
  // Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
  //   double originLat, 
  //   double originLng, 
  //   double destinationLat, 
  //   double destinationLng
  // ) async {

  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/driver-trip-requests/${originLat}/${originLng}/${destinationLat}/${destinationLng}');
  //     Map<String, String> headers = { 'Content-Type': 'application/json' };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       TimeAndDistanceValues timeAndDistanceValues = TimeAndDistanceValues.fromJson(data);
  //       return Success(timeAndDistanceValues);
  //     } else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return ErrorData(e.toString());
  //   }
  // }

  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng
  ) async {
    try {
      // Construimos la ruta con los parámetros
      String path = '/driver-trip-requests/$originLat/$originLng/$destinationLat/$destinationLng';
      
      // Hacemos la petición con el método GET a la ruta construida
      Response response = await serviceHandler.request(
        "GET", 
        path, 
        1, 
        168,
        refresh: true,
      );
      
      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        TimeAndDistanceValues timeAndDistanceValues = TimeAndDistanceValues.fromJson(response.data);
        return Success(timeAndDistanceValues);
      } else {
        print(response.statusCode);
        print(response.data['message']);
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

  // Creacion de un viaje
  // Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-request/create');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };
  //     String body = json.encode(driverTripRequest);

  //     final response = await http.post(url, headers: headers, body: body);
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       TripDetail driverTripResponse = TripDetail.fromJson(data);
  //       return Success(driverTripResponse);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
      
  //   } catch (error) {
  //     print('Error CreateTrip: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<TripDetail>> create(DriverTripRequest driverTripRequest) async {
    try {
      // Construimos la ruta para la creación del viaje
      String path = '/trip-request/create';
      
      // Hacemos la petición con el método POST a la ruta construida
      Response response = await serviceHandler.request(
        "POST", 
        path, 
        1, 
        168,
        body: driverTripRequest.toJson(), // Convertimos el objeto a JSON
        refresh: true, // Forzamos la solicitud para evitar la caché
      );
      
      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        TripDetail driverTripResponse = TripDetail.fromJson(response.data);
        return Success(driverTripResponse);
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
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
  // Future<Resource<TripDetail>> getTripDetail(int idTrip) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-request/findOne/$idTrip');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       TripDetail tripDetail = TripDetail.fromJson(data);
  //       return Success(tripDetail);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error GetTripDetail Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<TripDetail>> getTripDetail(int idTrip) async {
    try {
      // Construimos la ruta para obtener el detalle del viaje
      String path = '/trip-request/findOne/$idTrip';
      
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
        TripDetail tripDetail = TripDetail.fromJson(response.data);
        return Success(tripDetail);
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
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
  // Future<Resource<TripsAll>> getDriverTrips() async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-request/driver-trips');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     print(response);
  //     print('Data: $data');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       TripsAll driverTripsAll = TripsAll.fromJson(data); 
  //       return Success(driverTripsAll);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error getDriverTrips Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<TripsAll>> getDriverTrips() async {
    try {
      Response driverTripsRes = await serviceHandler.request("GET", "/trip-request/driver-trips", 1, 168,);
      print(driverTripsRes);
      TripsAll driverTrips = TripsAll.fromJson(driverTripsRes.data); 
      return Success(driverTrips);
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
  // Future<Resource<List<TripDetail>>> getAvailableTrips() async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/trip-request/findAll');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       List<TripDetail> availableTripsAll = TripDetail.fromJsonList(data); 
  //       return Success(availableTripsAll);
  //     }
  //     else {
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error GetTripsAll Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<List<TripDetail>>> getAvailableTrips() async {
    try {
      Response availableTripsAllRes = await serviceHandler.request("GET", "/trip-request/findAll", 1, 168,);
      print(availableTripsAllRes);
      List<TripDetail> availableTripsAll = TripDetail.fromJsonList(availableTripsAllRes.data); 
      return Success(availableTripsAll);
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