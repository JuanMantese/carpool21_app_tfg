import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CarRegisterState extends Equatable {
  final int currentStep; // Indice del paso actual

  // Register Form - Use GlobalKey
  final GlobalKey<FormState>? formKey;
  final GlobalKey<FormState>? formKeyInsurance;
  final int id;
  final BlocFormItem brand; // Marca
  final BlocFormItem model; // Modelo
  final BlocFormItem patent; // Patente
  final BlocFormItem year; // Año del auto
  final BlocFormItem color; // Color del auto
  final BlocFormItem nroGreenCard; // Numero Cedula Verde
  final BlocFormItem insuranceCompany; // Compania de Seguro
  final BlocFormItem insuranceType; // Tipo de Seguro
  final BlocFormItem insuranceExpiration; // Expiración del Seguro
  final BlocFormItem policyNumber; // Nro de Poliza
  final BlocFormItem cuilCuit; // Cuil Cuit del Usuario de la Poliza
  final Resource? response; 

  const CarRegisterState({
    this.currentStep = 0,
    this.formKey,
    this.formKeyInsurance,
    this.id = 0,
    this.brand = const BlocFormItem(error: 'Ingresá la Marca'),
    this.model = const BlocFormItem(error: 'Ingresá el Modelo'),
    this.patent = const BlocFormItem(error: 'Ingresá la patente'),
    this.year = const BlocFormItem(error: 'Ingresá el Año del Vehículo'),
    this.color = const BlocFormItem(error: 'Elegí el color'),
    this.nroGreenCard = const BlocFormItem(error: 'Ingresá el Nro de Cedula Verde'),
    this.insuranceCompany = const BlocFormItem(error: 'Ingresá la compañia de seguros'),
    this.insuranceType = const BlocFormItem(error: 'Ingresá el tipo de seguro'),
    this.insuranceExpiration = const BlocFormItem(error: 'Ingresá la fecha de expiración del seguro'),
    this.policyNumber = const BlocFormItem(error: 'Ingresá el número de póliza'),
    this.cuilCuit = const BlocFormItem(error: 'Ingresá tu Nro de CUIL o CUIT'),
    this.response
  });

  CarRegisterState copyWith({
    int? currentStep,
    GlobalKey<FormState>? formKey,
    GlobalKey<FormState>? formKeyInsurance,
    int? id,
    BlocFormItem? brand,
    BlocFormItem? model,
    BlocFormItem? patent,
    BlocFormItem? year,
    BlocFormItem? color,
    BlocFormItem? nroGreenCard,
    BlocFormItem? insuranceCompany,
    BlocFormItem? insuranceType,
    BlocFormItem? insuranceExpiration,
    BlocFormItem? policyNumber,
    BlocFormItem? cuilCuit,
    Resource? response,
  }) {
    return CarRegisterState(
      currentStep: currentStep ?? this.currentStep,
      formKey: formKey ?? this.formKey,
      formKeyInsurance: formKeyInsurance ?? this.formKeyInsurance,
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      patent: patent ?? this.patent,
      year: year ?? this.year,
      color: color ?? this.color,
      nroGreenCard: nroGreenCard ?? this.nroGreenCard,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insuranceType: insuranceType ?? this.insuranceType,
      insuranceExpiration: insuranceExpiration ?? this.insuranceExpiration,
      policyNumber: policyNumber ?? this.policyNumber,
      cuilCuit: cuilCuit ?? this.cuilCuit,
      response: response
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    brand, 
    model, 
    patent, 
    year, 
    color, 
    nroGreenCard,
    insuranceCompany,
    insuranceType,
    insuranceExpiration,
    policyNumber,
    cuilCuit,
    response
  ];
}