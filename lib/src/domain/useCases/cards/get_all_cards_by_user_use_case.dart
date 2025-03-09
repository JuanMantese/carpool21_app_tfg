import 'package:carpool_21_app/src/domain/repository/cards_repository.dart';

class GetAllCardsByUserUseCase {

  CardsRepository cardsRepository;

  GetAllCardsByUserUseCase(this.cardsRepository);

  run(int idUser) => cardsRepository.getAllCardsByUser(idUser);
}