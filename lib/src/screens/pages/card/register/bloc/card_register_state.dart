import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CardRegisterState extends Equatable {
  // Register Form - Use GlobalKey
  final GlobalKey<FormState>? formKey;
  final BlocFormItem cardNumber;
  final BlocFormItem cardHolder;
  final BlocFormItem expiryDate;
  final BlocFormItem cvv;
  final Resource? createdCardRes;

  const CardRegisterState({
    this.formKey,
    this.cardNumber = const BlocFormItem(error: 'Ingresá el Número de la Tarjeta'),
    this.cardHolder = const BlocFormItem(error: 'Ingresá el nombre del titular'),
    this.expiryDate = const BlocFormItem(value: ''),
    this.cvv = const BlocFormItem(error: 'Ingresá el código de 3 o 4 digitos'),
    this.createdCardRes
  });

  CardRegisterState copyWith({
    GlobalKey<FormState>? formKey,
    BlocFormItem? cardNumber,
    BlocFormItem? cardHolder,
    BlocFormItem? expiryDate,
    BlocFormItem? cvv,
    Resource? createdCardRes,
  }) {
    return CardRegisterState(
      formKey: formKey ?? this.formKey,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      createdCardRes: createdCardRes ?? this.createdCardRes
    );
  }

  @override
  List<Object?> get props => [
    formKey,
    cardNumber, 
    cardHolder, 
    expiryDate,
    cvv, 
    createdCardRes
  ];
}