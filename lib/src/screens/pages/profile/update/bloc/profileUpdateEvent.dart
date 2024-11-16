
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class ProfileUpdateEvent {}

class ProfileUpdateInitEvent extends ProfileUpdateEvent {

  final User? user;

  ProfileUpdateInitEvent({
    required this.user
  });
}

// Input Name Event
class NameChanged extends ProfileUpdateEvent {
  final BlocFormItem nameInput;
  NameChanged({ required this.nameInput }); 
}

// Input Last Name Event
class LastNameChanged extends ProfileUpdateEvent {
  final BlocFormItem lastNameInput;
  LastNameChanged({ required this.lastNameInput }); 
}

// Input Phone Event
class PhoneChanged extends ProfileUpdateEvent {
  final BlocFormItem phoneInput;
  PhoneChanged({ required this.phoneInput }); 
}

// Input Address Event
class AddressChanged extends ProfileUpdateEvent {
  final BlocFormItem addressInput;
  AddressChanged({ required this.addressInput }); 
}

// Input Contact Name Event
class ContactNameChanged extends ProfileUpdateEvent {
  final BlocFormItem contactNameInput;
  ContactNameChanged({ required this.contactNameInput }); 
}

// Input Contact Last Name Event
class ContactLastNameChanged extends ProfileUpdateEvent {
  final BlocFormItem contactLastNameInput;
  ContactLastNameChanged({ required this.contactLastNameInput }); 
}

// Input Contact Phone Event
class ContactPhoneChanged extends ProfileUpdateEvent {
  final BlocFormItem contactPhoneInput;
  ContactPhoneChanged({ required this.contactPhoneInput }); 
}

// Pikc Image of the gallery
class PickImage extends ProfileUpdateEvent {}

// Teke Photo with camera
class TakePhoto extends ProfileUpdateEvent {}

// Submit Form Event
class FormSubmit extends ProfileUpdateEvent {}

// Save User Session Event
class UpdateUserSession extends ProfileUpdateEvent {
  final User user;
  UpdateUserSession({ required this.user});
}

