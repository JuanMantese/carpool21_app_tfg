import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class RegisterEvent {}

class RegisterInitEvent extends RegisterEvent {}

// Input Name Event
class NameChanged extends RegisterInitEvent {
  final BlocFormItem nameInput;
  NameChanged({ required this.nameInput }); 
}

// Input Last Name Event
class LastNameChanged extends RegisterInitEvent {
  final BlocFormItem lastNameInput;
  LastNameChanged({ required this.lastNameInput }); 
}

// Input UserId Event
class StudentFileInputChanged extends RegisterInitEvent {
  final BlocFormItem studentFileInput;
  StudentFileInputChanged({ required this.studentFileInput }); 
}

// Input DNI Event
class DniChanged extends RegisterInitEvent {
  final BlocFormItem dniInput;
  DniChanged({ required this.dniInput }); 
}

// Input Phone Event
class PhoneChanged extends RegisterInitEvent {
  final BlocFormItem phoneInput;
  PhoneChanged({ required this.phoneInput }); 
}

// Input Address Event
class AddressChanged extends RegisterInitEvent {
  final BlocFormItem addressInput;
  AddressChanged({ required this.addressInput }); 
}

// Input Email Event
class EmailChanged extends RegisterInitEvent {
  final BlocFormItem emailInput;
  EmailChanged({ required this.emailInput }); 
}

// Input Password Event
class PasswordChanged extends RegisterInitEvent {
  final BlocFormItem passwordInput;
  PasswordChanged({ required this.passwordInput }); 
}

// Input Confirm Password Event
class PasswordConfirmChanged extends RegisterInitEvent {
  final BlocFormItem passwordConfirmInput;
  PasswordConfirmChanged({ required this.passwordConfirmInput }); 
}

// Input Contact Name Event
class ContactNameChanged extends RegisterInitEvent {
  final BlocFormItem contactNameInput;
  ContactNameChanged({ required this.contactNameInput }); 
}

// Input Contact Last Name Event
class ContactLastNameChanged extends RegisterInitEvent {
  final BlocFormItem contactLastNameInput;
  ContactLastNameChanged({ required this.contactLastNameInput }); 
}

// Input Contact Phone Event
class ContactPhoneChanged extends RegisterInitEvent {
  final BlocFormItem contactPhoneInput;
  ContactPhoneChanged({ required this.contactPhoneInput }); 
}

// Submit Form Event
class FormSubmit extends RegisterInitEvent {}

// Reset Form Event
class FormReset extends RegisterInitEvent {}

// Save User Session Event
class SaveUserSession extends RegisterInitEvent {
  final AuthResponse authResponse;
  SaveUserSession({ required this.authResponse});
}