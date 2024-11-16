import 'dart:io';
import 'dart:convert';
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class UsersService {

  ServiceHandler serviceHandler;
  Future<String> token;

  // Constructor
  UsersService(this.serviceHandler, this.token);

  // To update a user's data, we need the Session Token
  // Future<Resource<User>> update(int id, User user) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/users/$id'); // Creation of the URL path
      
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': await token
  //     }; // We specify that the information sent is of type JSON
      
  //     String body = json.encode({
  //       'name': user.name,
  //       'lastName': user.lastName, 
  //       'studentFile': user.studentFile,
  //       'dni': user.dni,
  //       'phone': user.phone,
  //       'address': user.address,
  //       'contactName': user.contactName,
  //       'contactLastName': user.contactLastName,
  //       'contactPhone': user.contactPhone,
  //     });

  //     // Making the request. I specify the URL, the headers and the body
  //     final response = await http.put(url, headers: headers, body: body);

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       User userResponse = User.fromJson(data);
  //       print('Data Remote: ${user.toJson()}');

  //       return Success(userResponse);
  //     } else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<User>> update(int id, User user) async {
    try {
      // Construimos la ruta para actualizar el usuario
      String path = '/users/$id';
      
      // Creamos el cuerpo de la solicitud con los datos del usuario
      Map<String, dynamic> body = {
        'name': user.name,
        'lastName': user.lastName, 
        'studentFile': user.studentFile,
        'dni': user.dni,
        'phone': user.phone,
        'address': user.address,
        'contactName': user.contactName,
        'contactLastName': user.contactLastName,
        'contactPhone': user.contactPhone,
      };

      // Hacemos la petición con el método PUT a la ruta construida
      Response response = await serviceHandler.request(
        "PUT", 
        path, 
        1, 
        168,
        body: body, // Enviamos el cuerpo de la solicitud
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(response.data);
        print('Data Remote: ${userResponse.toJson()}');
        return Success(userResponse);
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


  // Update with Image
  // Future<Resource<User>> updateImage(int id, User user, File image) async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/users/upload/$id'); // Creation of the URL path
      
  //     final request = http.MultipartRequest('PUT', url); // Build the request

  //     request.headers['Authorization'] = await token; // Define the header

  //     // Assembling the file that we are going to send to the back
  //     request.files.add(http.MultipartFile(
  //       'file',  // Identifier that we define in the backend
  //       http.ByteStream(image.openRead().cast()),
  //       await image.length(), // File size
  //       filename: basename(image.path),  // File Name
  //       contentType: MediaType('image', 'jpg') // Indicate what we are going to upload, and what type of file it is
  //     ));

  //     // Assemble the body with the fields that we are going to send
  //     request.fields['name'] = user.name;
  //     request.fields['lastname'] = user.lastName;
  //     // request.fields['studentFile'] = user.studentFile;
  //     request.fields['dni'] = user.dni.toString();
  //     request.fields['phone'] = user.phone.toString();
  //     request.fields['address'] = user.address;
  //     request.fields['contactName'] = user.contactName;
  //     request.fields['contactLastName'] = user.contactLastName;
  //     request.fields['contactPhone'] = user.contactPhone.toString();

  //     // Send request
  //     final response = await request.send();

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(await response.stream.transform(utf8.decoder).first);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       User userResponse = User.fromJson(data);
  //       return Success(userResponse);
  //     } else {
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<User>> updateImage(int id, User user, File image) async {
    try {
      // Construimos la ruta para actualizar la imagen del usuario
      String path = '/users/upload/$id';
      
      // Convertir la imagen a base64
      String base64Image = base64Encode(await image.readAsBytes());

      // Creamos los datos del cuerpo de la solicitud
      Map<String, dynamic> body = {
        'name': user.name,
        'lastName': user.lastName,
        // 'studentFile': user.studentFile,
        'dni': user.dni.toString(),
        'phone': user.phone.toString(),
        'address': user.address,
        'contactName': user.contactName,
        'contactLastName': user.contactLastName,
        'contactPhone': user.contactPhone.toString(),
        'image': base64Image, // Añadir la imagen codificada en base64
        'imageName': basename(image.path), // Nombre del archivo
      };

      // Hacemos la petición con el método PUT a la ruta construida
      Response response = await serviceHandler.request(
        "PUT", 
        path, 
        1, 
        168,
        body: body, // Enviamos el formulario con los datos y el archivo
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(response.data);
        return Success(userResponse);
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

  // Future<Resource<User>> getUserDetail() async {
  //   try {
  //     Uri url = Uri.http(ApiConfig.API_CARPOOL21, '/users/details'); // Creation of the URL path
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await token}'
  //     }; // We specify that the information sent is of type JSON

  //     // Making the request. I specify the URL, the headers and the body
  //     final response = await http.get(url, headers: headers);

  //     // Decoding the information to be able to interpret it in Dart
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       User userResponse = User.fromJson(data);
  //       print('Data getUserDetail: ${userResponse.toJson()}');

  //       return Success(userResponse);
  //     } else {
  //       print('Response status getUserDetail: ${response.statusCode}');
  //       print('Response body getUserDetail: ${response.body}');
  //       return ErrorData(listToString(data['message']));
  //     }
  //   } catch (error) {
  //     print('Error changeRol Service: $error');
  //     return ErrorData(error.toString());
  //   }
  // }

  Future<Resource<User>> getUserDetail() async {
    try {
      // Construimos la ruta para obtener los detalles del usuario
      String path = '/users/details';
      
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
        User userResponse = User.fromJson(response.data);
        print('Data getUserDetail: ${userResponse.toJson()}');
        return Success(userResponse);
      } else {
        print('Response status getUserDetail: ${response.statusCode}');
        print('Response body getUserDetail: ${response.data}');
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