import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class LoginEvent {}

// Event to initialize the form
class LoginInitEvent extends LoginEvent {}

// Input Email Event
class EmailChanged extends LoginInitEvent {
  final BlocFormItem emailInput;
  EmailChanged({ required this.emailInput }); 
}

// Input Password Event
class PasswordChanged extends LoginInitEvent {
  final BlocFormItem passwordInput;
  PasswordChanged({ required this.passwordInput }); 
}

// Submit From Event
class FormSubmit extends LoginInitEvent {}

// Save User Session Event
class SaveUserSession extends LoginEvent {
  final AuthResponse authResponse;
  SaveUserSession({ required this.authResponse});
}