// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/trip_status.dart';
import 'package:carpool_21_app/src/domain/models/trips_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class DriverTripRequestsService {

  ServiceHandler serviceHandler;
  Future<String> token;

  DriverTripRequestsService(this.serviceHandler, this.token);

  // Creacion de un viaje
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

  // Consultamos el Tiempo estimado del viaje y su Distancia del origen al destino
  Future<Resource<TimeAndDistanceValues>> getTimeAndDistanceClientRequets(
    double originLat, 
    double originLng, 
    double destinationLat, 
    double destinationLng,
    String departureTime
  ) async {
    try {
      // Construimos la ruta con los parámetros
      String path = '/trip-request/get-time-and-distance';
      
      // Creamos el body en formato JSON con todos los parámetros
      Map<String, dynamic> bodyFormat = {
        "originLat": originLat,
        "originLng": originLng,
        "destinationLat": destinationLat,
        "destinationLng": destinationLng,
        "departureTime": departureTime,
      };

      // Hacemos la petición con el método GET a la ruta construida
      Response response = await serviceHandler.request(
        "POST", 
        path, 
        1, 
        168,
        body: bodyFormat,
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

  // Recupera el detalle de un viaje especifico
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

  // Recupera todos los viajes que pertenecen a un conductor
  Future<Resource<TripsAll>> getDriverTrips() async {
    try {
      Response driverTripsRes = await serviceHandler.request(
        "GET", 
        "/trip-request/driver-trips", 
        1, 
        168
      );

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

  // Recupera todos los viajes disponibles (cuyo state sea CREADO y con lugares disponibles)
  Future<Resource<List<TripDetail>>> getAvailableTrips() async {
    try {
      Response availableTripsAllRes = await serviceHandler.request(
        "GET", 
        "/trip-request/findAllAvailable", 
        1, 
        168
      );

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

  // Metodo para actualizar el estado de un viaje
  Future<Resource<TripStatus>> updateTripStatus(int idTrip, int newStatus) async {
    try {
      // Construimos la ruta con los parámetros
      String path = '/trip-request/status/$idTrip';
      
      // Creamos el body en formato JSON con todos los parámetros
      Map<String, dynamic> bodyFormat = {
        "newStatus": newStatus,
      };

      // Ejecutamos la petición
      Response response = await serviceHandler.request(
        "PATCH",
        path,
        1, 
        168,
        body: bodyFormat
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        TripStatus tripStatusUpdated = TripStatus.fromJson(response.data);
        return Success(tripStatusUpdated);
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
}