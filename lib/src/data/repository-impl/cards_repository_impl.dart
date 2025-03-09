

import 'package:carpool_21_app/src/data/dataSource/remote/services/cards_service.dart';
import 'package:carpool_21_app/src/domain/models/card_detail.dart';
import 'package:carpool_21_app/src/domain/models/card_request.dart';
import 'package:carpool_21_app/src/domain/repository/cards_repository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class CardsRepositoryImpl implements CardsRepository {

  CardsService cardsService;

  CardsRepositoryImpl(this.cardsService);

  @override
  Future<Resource<CardDetail>> create(CardRequest cardRequest, int idUser) {
    return cardsService.create(cardRequest, idUser);
  }

  @override
  Future<Resource<CardDetail>> getCardByUser(int idUser, int idCard) {
    return cardsService.getCardByUser(idUser, idCard);
  }

  @override
  Future<Resource<List<CardDetail>>> getAllCardsByUser(int idUser) {
    return cardsService.getAllCardsByUser(idUser);
  }
}