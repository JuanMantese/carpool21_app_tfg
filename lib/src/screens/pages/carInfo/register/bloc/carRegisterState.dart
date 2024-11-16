
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class CarRegisterState extends Equatable {

  // Register Form - Use GlobalKey
  final GlobalKey<FormState>? formKey;
  final int id;
  final BlocFormItem brand; // Marca
  final BlocFormItem model; // Modelo
  final BlocFormItem patent; // Patente
  final BlocFormItem year; // Año del auto
  final BlocFormItem color; // Color del auto
  final BlocFormItem nroGreenCard; // Numero Cedula Verde
  final Resource? response; 

  const CarRegisterState({
    this.formKey,
    this.id = 0,
    this.brand = const BlocFormItem(error: 'Ingresá la Marca'),
    this.model = const BlocFormItem(error: 'Ingresá el Modelo'),
    this.patent = const BlocFormItem(error: 'Ingresá la patente'),
    this.year = const BlocFormItem(error: 'Ingresá el Año del Vehículo'),
    this.color = const BlocFormItem(error: 'Elegí el color'),
    this.nroGreenCard = const BlocFormItem(error: 'Ingresá el Nro de Cedula Verde'),
    this.response
  });

  CarRegisterState copyWith({
    GlobalKey<FormState>? formKey,
    int? id,
    BlocFormItem? brand,
    BlocFormItem? model,
    BlocFormItem? patent,
    BlocFormItem? year,
    BlocFormItem? color,
    BlocFormItem? nroGreenCard,
    Resource? response,
  }) {
    return CarRegisterState(
      formKey: formKey,
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      patent: patent ?? this.patent,
      year: year ?? this.year,
      color: color ?? this.color,
      nroGreenCard: nroGreenCard ?? this.nroGreenCard,
      response: response
    );
  }

  @override
  List<Object?> get props => [brand, model, patent, year, color, nroGreenCard, response];
}