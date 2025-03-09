// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/data/dataSource/remote/service_handler.dart';
import 'package:carpool_21_app/src/domain/models/card_detail.dart';
import 'package:carpool_21_app/src/domain/models/card_request.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:dio/dio.dart';

class CardsService {

  ServiceHandler serviceHandler;
  Future<String> token;

  // Constructor
  CardsService(this.serviceHandler, this.token);

  // Creando una nueva tarjeta del usuario
  Future<Resource<CardDetail>> create(CardRequest cardRequest, int idUser) async {
    try {
      // Construimos la ruta para la creación de la tarjeta
      String path = '/cards/$idUser';
      
      // Creamos el cuerpo de la solicitud con los datos de la tarjeta
      Map<String, dynamic> body = cardRequest.toJson();

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
        CardDetail cardDetail = CardDetail.fromJson(response.data);
        print('Data createCard: ${cardDetail.toJson()}');
        return Success(cardDetail);
      } else {
        print('ERROR createCard Service --------------------------------');
        print('status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return ErrorData(response.data['message']);
      }
    } catch (e) {
      print('CreateCard Service Error');
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

  // Consultando el detalle de una tarjeta
  Future<Resource<CardDetail>> getCardByUser(int idUser, int idCard) async {
    try {
      // Construimos la ruta para obtener el detalle de una tarjeta
      String path = '/cards/$idUser/$idCard';
      
      // Hacemos la petición con el método GET a la ruta construida
      Response cardDetailRes = await serviceHandler.request(
        "GET", 
        path, 
        1, 
        168,
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (cardDetailRes.statusCode == 200 || cardDetailRes.statusCode == 201) {
        CardDetail cardDetail = CardDetail.fromJson(cardDetailRes.data);
        print('Data getCardByUser: ${cardDetail.toJson()}');
        return Success(cardDetail);
      } else {
        print('ERROR getCardByUser Service --------------------------------');
        print('status: ${cardDetailRes.statusCode}');
        print('Response body: ${cardDetailRes.data}');
        return ErrorData(cardDetailRes.data['message']);
      }
    } catch (e) {
      print('GetCardByUser Service Error');
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

  // Consultando todas las tarjetas de un usuario
  Future<Resource<List<CardDetail>>> getAllCardsByUser(int idUser) async {
    try {
      Response cardsAllRes = await serviceHandler.request(
        "GET", 
        "/cards/findAllByUser/$idUser", 
        1, 
        168,
        refresh: true, // Forzamos la solicitud para evitar la caché
      );

      // Procesamos la respuesta
      if (cardsAllRes.statusCode == 200 || cardsAllRes.statusCode == 201) {
        // Devuelve una lista con todos los vehículos del driver
        List<CardDetail> carList = (cardsAllRes.data as List)
          .map((car) => CardDetail.fromJson(car))
          .toList();
        return Success(carList);
      } else {
        print('ERROR getAllCardsByUser Service --------------------------------');
        print('status: ${cardsAllRes.statusCode}');
        print('Response body: ${cardsAllRes.data}');
        return ErrorData(cardsAllRes.data['message']);
      }
    } catch (e) {
      print('GetAllCardsByUser Service Error');
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