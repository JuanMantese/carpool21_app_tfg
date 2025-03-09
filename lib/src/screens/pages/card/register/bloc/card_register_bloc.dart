
import 'package:carpool_21_app/src/domain/models/card_request.dart';
import 'package:carpool_21_app/src/domain/useCases/cards/cards_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/bloc/card_register_event.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/bloc/card_register_state.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardRegisterBloc extends Bloc<CardRegisterEvent, CardRegisterState> {

  // AuthUseCases authUseCases;
  CardsUseCases cardsUseCases;
  // UserUseCases userUseCases;

  final formKey = GlobalKey<FormState>();

  // Constructor
  CardRegisterBloc(
    // this.authUseCases,
    this.cardsUseCases,
    // this.userUseCases,
  ): super(const CardRegisterState()) {

    // We initialize the form with the values ​​of the current User
    on<CardRegisterInitEvent>((event, emit) {
      emit(
        state.copyWith(
          formKey: formKey,
        ));
    });

    on<CardNumberChanged>((event, emit) {
      final cardNumberValue = event.cardNumberInput.value;
      String? error;

      if (cardNumberValue.isEmpty) {
        error = 'Ingrese el número de la tarjeta';
      } else if (cardNumberValue.length < 15 || cardNumberValue.length > 16) {
        error = 'El número de la tarjeta debe tener entre 15 y 16 dígitos';
      }

      emit(
        state.copyWith(
          cardNumber: BlocFormItem(
            value: cardNumberValue,
            error: error
          ),
          formKey: formKey
        )
      );
    });

    on<CardHolderChanged>((event, emit) {
      emit(
        state.copyWith(
          cardHolder: BlocFormItem(
            value: event.cardHolderInput.value,
            error: event.cardHolderInput.value.isEmpty ? 'Ingrese el nombre del titular' : null
          ),
          formKey: formKey
        )
      );
    });

    on<ExpiryDateChanged>((event, emit) {
      emit(
        state.copyWith(
          expiryDate: BlocFormItem(
            value: event.expiryDateInput.value,
            error: event.expiryDateInput.value.isEmpty ? 'Ingrese la fecha de expiración' : null
          ),
          formKey: formKey
        )
      );
    });

    on<CvvChanged>((event, emit) {
      emit(
        state.copyWith(
          cvv: BlocFormItem(
            value: event.cvvInput.value,
            error: event.cvvInput.value.isEmpty ? 'Ingrese el CVV' : null
          ),
          formKey: formKey
        )
      );
    });

    on<FormSubmit>((event, emit) async {
      print('CardNumber: ${ state.cardNumber.value }');
      print('CardHolder: ${ state.cardHolder.value }');
      print('ExpirationDate: ${ state.expiryDate.value }');
      print('CVV: ${ state.cvv.value }');

      // Issuance of status change - Loading
      emit(
        state.copyWith(
          createdCardRes: Loading(),
          formKey: formKey,
        )
      );

      // PARA QUE APAREZCA El estado de Loading (circle) - Tirar el Back y que quede cargando - ELIMINAR
      Resource response = await cardsUseCases.createCard.run(
        CardRequest(
          cardNumber: state.cardNumber.value, 
          ownerName: state.cardHolder.value, 
          expirationDate: CardRequest.rotateExpirationDate(state.expiryDate.value),
          cvv: int.parse(state.cvv.value),
        ),
        12
      );

      // Issuance of status change - Success/Error
      emit(
        state.copyWith(
          createdCardRes: response,
          formKey: formKey,
        )
      );
    });
  }
}
    