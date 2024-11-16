
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class CarUpdateState extends Equatable {

  // Register Form - Use GlobalKey
  final GlobalKey<FormState>? formKey;
  final int id;
  final BlocFormItem brand; // Marca
  final BlocFormItem model; // Modelo
  final BlocFormItem patent; // Patente
  final BlocFormItem color; // Color del auto
  final BlocFormItem year; // Seguro del auto
  final BlocFormItem nroGreenCard; // Numero Cedula Verde
  final Resource? response; 

  const CarUpdateState({
    this.formKey,
    this.id = 0,
    this.brand = const BlocFormItem(error: 'Ingresá la Marca'),
    this.model = const BlocFormItem(error: 'Ingresá el Modelo'),
    this.patent = const BlocFormItem(error: 'Ingresá la patente'),
    this.color = const BlocFormItem(error: 'Elegí el color'),
    this.year = const BlocFormItem(error: 'Ingresá el Año del Vehiculo'),
    this.nroGreenCard = const BlocFormItem(error: 'Ingresá el Nro de Cedula Verde'),
    this.response
  });

  CarUpdateState copyWith({
    GlobalKey<FormState>? formKey,
    int? id,
    BlocFormItem? brand,
    BlocFormItem? model,
    BlocFormItem? patent,
    BlocFormItem? color,
    BlocFormItem? year,
    BlocFormItem? nroGreenCard,
    Resource? response,
  }) {
    return CarUpdateState(
      formKey: formKey,
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      patent: patent ?? this.patent,
      color: color ?? this.color,
      year: year ?? this.year,
      nroGreenCard: nroGreenCard ?? this.nroGreenCard,
      response: response
    );
  }

  // Carinfo Class with required parameters
  toCarInfo() => CarInfo(
    brand: brand.value,
    model: model.value,
    patent: patent.value,
    color: color.value,
    year: int.tryParse(year.value) ?? 0,
    nroGreenCard: nroGreenCard.value,
  );

  @override
  List<Object?> get props => [brand, model, patent, color, year, nroGreenCard, response];
}