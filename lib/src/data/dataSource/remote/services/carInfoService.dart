import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class CarInfoService {

  ServiceHandler serviceHandler;
  Future<String> token;

  // Constructor
  CarInfoService(this.serviceHandler, this.token);

  // Registrando un nuevo vehiculo
  // Future<Resource<CarInfo>> create(CarInfo carInfo) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/vehicles/create');

  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };
      
  //     String body = json.encode(carInfo);

  //     final response = await http.post(url, headers: headers, body: body);
  //     final data = json.decode(response.body);
      
  //     print('Create Vehicle: ${data}');
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       CarInfo carInfoResponse = CarInfo.fromJson(data);
  //       print('Data Remote: ${carInfoResponse.toJson()}');

  //       return Success(carInfoResponse);
  //     }
  //     else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<CarInfo>> create(CarInfo carInfo) async {
    try {
      // Hacemos la petición con el método POST a la ruta /vehicles/create
      Response response = await serviceHandler.request(
        "POST", 
        "/vehicles/create", 
        1, 
        168,
        body: carInfo.toJson(),
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        CarInfo carInfoResponse = CarInfo.fromJson(response.data);
        print('Data Remote: ${carInfoResponse.toJson()}');

        return Success(carInfoResponse);
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

  // To update a carInfo data, we need the Session Token
  // Future<Resource<CarInfo>> update(int idDriver, CarInfo car) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/vehicles/$idDriver'); // Creation of the URL path
      
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     }; // We specify that the information sent is of type JSON
      
  //     String body = json.encode({
  //       'brand': car.brand,
  //       'model': car.model, 
  //       'patent': car.patent,
  //       'color': car.color,
  //       'year': car.year,
  //       'greenCard': car.nroGreenCard,
  //     });

  //     // Making the request. I specify the URL, the headers and the body
  //     final response = await http.put(url, headers: headers, body: body);

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       CarInfo carInfoResponse = CarInfo.fromJson(data);
  //       print('Data Remote: ${car.toJson()}');

  //       return Success(carInfoResponse);
  //     } else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<CarInfo>> update(int idDriver, CarInfo car) async {
    try {
      // Hacemos la petición con el método PUT a la ruta /vehicles/$idDriver
      Response response = await serviceHandler.request(
        "PUT", 
        "/vehicles/$idDriver", 
        1, 
        168,
        body: {
          'brand': car.brand,
          'model': car.model, 
          'patent': car.patent,
          'color': car.color,
          'year': car.year,
          'greenCard': car.nroGreenCard,
        },
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        CarInfo carInfoResponse = CarInfo.fromJson(response.data);
        print('Data Remote: ${car.toJson()}');

        return Success(carInfoResponse);
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

  // Trayendo el vehiculo del conductor
  // Future<Resource<CarInfo>> getCarInfo(int idDriver) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/vehicles/getUserVehicle/$idDriver');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       CarInfo carInfo = CarInfo.fromJson(data);
  //       return Success(carInfo);
  //     }
  //     else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<CarInfo>> getCarInfo(int idDriver) async {
    try {
      // Hacemos la petición con el método GET a la ruta /vehicles/getUserVehicle/$idDriver
      Response response = await serviceHandler.request(
        "GET", 
        "/vehicles/getUserVehicle/$idDriver", 
        1, 
        168,
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        CarInfo carInfo = CarInfo.fromJson(response.data);
        return Success(carInfo);
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

  // Trayendo el vehiculo del conductor
  // Consultando todos los vehiculos del conductor - getCarList: Array con los vehiculos del conductor
  // Future<Resource<List<CarInfo>>> getCarList() async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/vehicles/getUserAllVehicles');
  //     Map<String, String> headers = { 
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     };

  //     final response = await http.get(url, headers: headers);
  //     final data = json.decode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Devuelve una lista con todos los vehiculos del driver
  //       List<CarInfo> carList = CarInfo.fromJsonList(data); 
  //       return Success(carList);
  //      } else {
  //       print(response.statusCode);
  //       print(data['message']);
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<List<CarInfo>>> getCarList() async {
    try {
      // Hacemos la petición con el método GET a la ruta /vehicles/getUserAllVehicles
      Response response = await serviceHandler.request(
        "GET", 
        "/vehicles/getUserAllVehicles", 
        1, 
        168,
        refresh: true,
      );
      
      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Devuelve una lista con todos los vehículos del driver
        List<CarInfo> carList = (response.data as List)
          .map((car) => CarInfo.fromJson(car))
          .toList();
        return Success(carList);
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