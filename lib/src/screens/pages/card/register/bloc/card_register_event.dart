
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class CardRegisterEvent {}

class CardRegisterInitEvent extends CardRegisterEvent {}

class CardNumberChanged extends CardRegisterEvent {
  final BlocFormItem cardNumberInput;
  CardNumberChanged({ required this.cardNumberInput });
}

class CardHolderChanged extends CardRegisterEvent {
  final BlocFormItem cardHolderInput;
  CardHolderChanged({ required this.cardHolderInput });
}

class ExpiryDateChanged extends CardRegisterEvent {
  final BlocFormItem expiryDateInput;
  ExpiryDateChanged({ required this.expiryDateInput });
}

class CvvChanged extends CardRegisterEvent {
  final BlocFormItem cvvInput;
  CvvChanged({ required this.cvvInput });
}

// Submit Form Event
class FormSubmit extends CardRegisterEvent {}
