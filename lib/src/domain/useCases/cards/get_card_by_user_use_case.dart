import 'package:carpool_21_app/src/domain/repository/cards_repository.dart';

class GetCardByUserUseCase {

  CardsRepository cardsRepository;

  GetCardByUserUseCase(this.cardsRepository);

  run(int idUser, int idCard) => cardsRepository.getCardByUser(idUser, idCard);
}