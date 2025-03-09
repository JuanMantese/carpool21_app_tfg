

import 'package:carpool_21_app/src/domain/useCases/cards/create_card_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/cards/get_all_cards_by_user_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/cards/get_card_by_user_use_case.dart';

class CardsUseCases {

  CreateCardUseCase createCard;
  GetCardByUserUseCase getCardByUserUseCase;
  GetAllCardsByUserUseCase getAllCardsByUserUseCase;

  CardsUseCases({
    required this.createCard,
    required this.getCardByUserUseCase,
    required this.getAllCardsByUserUseCase
  });

}