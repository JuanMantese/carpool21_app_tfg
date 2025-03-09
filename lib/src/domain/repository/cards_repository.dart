import 'package:carpool_21_app/src/domain/models/card_detail.dart';
import 'package:carpool_21_app/src/domain/models/card_request.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class CardsRepository {

  // Creamos la tarjeta de un usuario
  Future<Resource<CardDetail>> create(CardRequest cardRequest, int idUser);

  // Obtenemos el detalle de una tarjeta
  Future<Resource<CardDetail>> getCardByUser(int idUser, int idCard);

  // Obtenemos todas las tarjetas registradas de un usuario
  Future<Resource<List<CardDetail>>> getAllCardsByUser(int idUser);
}