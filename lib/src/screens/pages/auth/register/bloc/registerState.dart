
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RegisterState extends Equatable {

  // Register Form - Use GlobalKey
  final GlobalKey<FormState>? formKeyRegister;
  final BlocFormItem name;
  final BlocFormItem lastName;
  final BlocFormItem studentFile;
  final BlocFormItem dni;
  final BlocFormItem phone;
  final BlocFormItem address;
  final BlocFormItem email;
  final BlocFormItem password;
  final BlocFormItem passwordConfirm;
  final BlocFormItem contactName;
  final BlocFormItem contactLastName;
  final BlocFormItem contactPhone;
  final Resource? response;

  const RegisterState({
    this.formKeyRegister,
    this.name = const BlocFormItem(error: 'Ingresa tu nommbre'),
    this.lastName = const BlocFormItem(error: 'Ingresa tu apellido'),
    this.studentFile = const BlocFormItem(error: 'Ingresa tu legajo de Sigo 21'),
    this.dni = const BlocFormItem(error: 'Ingresa tu D.N.I.'),
    this.phone = const BlocFormItem(error: 'Ingresa tu teléfono'),
    this.address = const BlocFormItem(error: 'Ingresa tu dirección'),
    this.email = const BlocFormItem(error: 'Ingresa tu correo electrónico'),
    this.password = const BlocFormItem(error: 'Ingresa una contraseña'),
    this.passwordConfirm = const BlocFormItem(error: 'Confirma la contraseña'),
    this.contactName = const BlocFormItem(error: 'Ingresa el nombre de tu contacto'),
    this.contactLastName = const BlocFormItem(error: 'Ingresa el apellido de tu contacto'),
    this.contactPhone = const BlocFormItem(error: 'Ingresa el teléfono de tu contacto'),
    this.response
  });

  RegisterState copyWith({
    GlobalKey<FormState>? formKeyRegister,
    BlocFormItem? name,
    BlocFormItem? lastName,
    BlocFormItem? studentFile,
    BlocFormItem? dni,
    BlocFormItem? phone,
    BlocFormItem? address,
    BlocFormItem? email,
    BlocFormItem? password,
    BlocFormItem? passwordConfirm,
    BlocFormItem? contactName,
    BlocFormItem? contactLastName,
    BlocFormItem? contactPhone,
    Resource? response,
  }) {
    return RegisterState(
      formKeyRegister: formKeyRegister,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      studentFile: studentFile ?? this.studentFile,
      dni: dni ?? this.dni,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      contactName: contactName ?? this.contactName,
      contactLastName: contactLastName ?? this.contactLastName,
      contactPhone: contactPhone ?? this.contactPhone,
      response: response
    );
  }

  // User Class with required parameters
  toUser() => User(
    name: name.value, 
    lastName: lastName.value, 
    studentFile: studentFile.value, 
    dni: int.tryParse(dni.value) ?? 0, 
    phone: int.tryParse(phone.value) ?? 0, 
    address: address.value, 
    email: email.value, 
    password: password.value, 
    passwordConfirm: passwordConfirm.value, 
    contactName: contactName.value, 
    contactLastName: contactLastName.value, 
    contactPhone: int.tryParse(contactPhone.value) ?? 0
  );

  @override
  List<Object?> get props => [name, lastName, studentFile, dni, phone, address, email, password, passwordConfirm, contactName, contactLastName, contactPhone, response];

}