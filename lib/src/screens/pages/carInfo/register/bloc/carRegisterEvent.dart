
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class CarRegisterEvent {}

class CarRegisterInitEvent extends CarRegisterEvent {}

// Input Brand Event
class BrandChanged extends CarRegisterEvent {
  final BlocFormItem brandInput;
  BrandChanged({ required this.brandInput }); 
}

// Input Model Event
class ModelChanged extends CarRegisterEvent {
  final BlocFormItem modelInput;
  ModelChanged({ required this.modelInput }); 
}

// Input Patent Event
class PatentChanged extends CarRegisterEvent {
  final BlocFormItem patentInput;
  PatentChanged({ required this.patentInput }); 
}

// Input Year Event
class YearChanged extends CarRegisterEvent {
  final BlocFormItem yearInput;
  YearChanged({ required this.yearInput }); 
}

// Input Color Event
class ColorChanged extends CarRegisterEvent {
  final BlocFormItem colorInput;
  ColorChanged({ required this.colorInput }); 
}

// Input NroGreenCard Event
class NroGreenCardChanged extends CarRegisterEvent {
  final BlocFormItem nroGreenCardInput;
  NroGreenCardChanged({ required this.nroGreenCardInput }); 
}

// Submit Form Event
class FormSubmit extends CarRegisterEvent {}

class UpdateUserSession extends CarRegisterEvent {}

