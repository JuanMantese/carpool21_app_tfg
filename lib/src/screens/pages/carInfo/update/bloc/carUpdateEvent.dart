
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class CarUpdateEvent {}

class CarUpdateInitEvent extends CarUpdateEvent {

  final CarInfo? car;

  CarUpdateInitEvent({
    required this.car
  });
}

// Input Brand Event
class BrandChanged extends CarUpdateEvent {
  final BlocFormItem brandInput;
  BrandChanged({ required this.brandInput }); 
}

// Input Model Event
class ModelChanged extends CarUpdateEvent {
  final BlocFormItem modelInput;
  ModelChanged({ required this.modelInput }); 
}

// Input Patent Event
class PatentChanged extends CarUpdateEvent {
  final BlocFormItem patentInput;
  PatentChanged({ required this.patentInput }); 
}

// Input Color Event
class ColorChanged extends CarUpdateEvent {
  final BlocFormItem colorInput;
  ColorChanged({ required this.colorInput }); 
}

// Input NroGreenCard Event
class NroGreenCardChanged extends CarUpdateEvent {
  final BlocFormItem nroGreenCardInput;
  NroGreenCardChanged({ required this.nroGreenCardInput }); 
}

// Input Year Event
class YearChanged extends CarUpdateEvent {
  final BlocFormItem yearInput;
  YearChanged({ required this.yearInput }); 
}

// Submit Form Event
class FormSubmit extends CarUpdateEvent {}

// Save User Session Event
// class UpdateUserSession extends CarUpdateEvent {
//   final CarInfo car;
//   UpdateUserSession({ required this.car});
// }

