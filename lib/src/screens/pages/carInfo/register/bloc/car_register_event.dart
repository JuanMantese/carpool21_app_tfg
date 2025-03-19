
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';

abstract class CarRegisterEvent {}

class CarRegisterInitEvent extends CarRegisterEvent {}

// Avanzar al siguiente paso para registro del Vehiculo
class NextStep extends CarRegisterEvent {}
// Retroceder al paso anterior para registro del Vehiculo
class PreviousStep extends CarRegisterEvent {}

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

// Input InsuranceCompany Event
class InsuranceCompanyChanged extends CarRegisterEvent {
  final BlocFormItem insuranceCompanyInput;
  InsuranceCompanyChanged({ required this.insuranceCompanyInput }); 
}

// Input InsuranceType Event
class InsuranceTypeChanged extends CarRegisterEvent {
  final BlocFormItem insuranceTypeInput;
  InsuranceTypeChanged({ required this.insuranceTypeInput }); 
}

// Input InsuranceExpiration Event
class InsuranceExpirationChanged extends CarRegisterEvent {
  final BlocFormItem insuranceExpirationInput;
  InsuranceExpirationChanged({ required this.insuranceExpirationInput }); 
}

// Input PolicyNumber Event
class PolicyNumberChanged extends CarRegisterEvent {
  final BlocFormItem policyNumberInput;
  PolicyNumberChanged({ required this.policyNumberInput }); 
}

// Input PolicyExpirationDate Event
class CuilCuitChanged extends CarRegisterEvent {
  final BlocFormItem cuilCuitInput;
  CuilCuitChanged({ required this.cuilCuitInput }); 
}

// Submit Form Event
class FormSubmit extends CarRegisterEvent {}

class UpdateUserSession extends CarRegisterEvent {}

// Reseteo los valores de createdCardRes
class ResetCreatedCarRes extends CarRegisterEvent {}

// Reseteo los valores del State al salir de la pantalla
class ResetState extends CarRegisterEvent {}
