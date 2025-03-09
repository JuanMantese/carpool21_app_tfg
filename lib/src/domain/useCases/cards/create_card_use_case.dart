import 'package:carpool_21_app/src/domain/models/card_request.dart';
import 'package:carpool_21_app/src/domain/repository/cards_repository.dart';

class CreateCardUseCase {

  CardsRepository cardsRepository;

  CreateCardUseCase(this.cardsRepository);

  run(CardRequest cardRequest, int idUser) => cardsRepository.create(cardRequest, idUser);
}