import 'dart:convert';
import 'package:carpool_21_app/src/data/api/apiConfig.dart';
import 'package:carpool_21_app/src/domain/models/driverPosition.dart';
import 'package:carpool_21_app/src/domain/utils/listToString.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:http/http.dart' as http;

class DriversPositionService {

  // Creando posicion del Driver
  Future<Resource<bool>> create(DriverPosition driverPosition) async {
    try {
      Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/drivers-position');
      Map<String, String> headers = { 'Content-Type': 'application/json' };
      String body = json.encode(driverPosition);

      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      } else {
        return ErrorData(listToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return ErrorData(e.toString());
    }
  }

  // Eliminando la posicion del Driver
  Future<Resource<bool>> delete(int idDriver) async {
    try {
      Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/drivers-position/${idDriver}');
      Map<String, String> headers = { 'Content-Type': 'application/json' };

      final response = await http.delete(url, headers: headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      } else {
        return ErrorData(listToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return ErrorData(e.toString());
    }
  }

  // Consultando posicion del Driver
  Future<Resource<DriverPosition>> getDriverPosition(int idDriver) async {
    try {
      Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/drivers-position/${idDriver}');
      Map<String, String> headers = { 'Content-Type': 'application/json' };

      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        DriverPosition driverPosition = DriverPosition.fromJson(data);
        return Success(driverPosition);
      } else {
        return ErrorData(listToString(data['message']));
      } 
    } catch (e) {
      print('Error: $e');
      return ErrorData(e.toString());
    }
  }
}