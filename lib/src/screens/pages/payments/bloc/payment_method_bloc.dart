// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/card_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/cards/cards_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/payments/bloc/payment_method_event.dart';
import 'package:carpool_21_app/src/screens/pages/payments/bloc/payment_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {

  AuthUseCases authUseCases;
  CardsUseCases cardsUseCases;

  PaymentMethodBloc(
    this.authUseCases,
    this.cardsUseCases
  ): super(const PaymentMethodState(
    paymentsRes: null
  )) {

    on<LoadPaymentMethods>((event, emit) async {
      emit(
        state.copyWith(
          paymentsRes: Loading()
        )
      );

      AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse != null && authResponse.user != null) {
        // Recuperando las tarjetas del usuario
        Resource<List<CardDetail>> reserveDetailRes = await cardsUseCases.getAllCardsByUserUseCase.run(authResponse.user?.idUser ?? 12);

        emit(
          state.copyWith(
            paymentsRes: reserveDetailRes
          )
        );
      } else {
        print('******************* LoadPaymentMethods - AuthResponse es Null *******************');
        emit(
          state.copyWith(
            paymentsRes: ErrorData('LoadPaymentMethods - AuthResponse es Null')
          )
        );
      }
    });
  }
}