import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {

  // Screen with Form - Use GlobalKey
  final GlobalKey<FormState>? formKeyLogin;
  final BlocFormItem email;
  final BlocFormItem password;
  final Resource? response;

  const LoginState({
    this.formKeyLogin,
    this.email = const BlocFormItem(error: 'Ingresa tu email'),
    this.password = const BlocFormItem(error: 'Ingresa tu contrasena'),
    this.response,
  });

  // Instance of the LoginState class
  LoginState copyWith({
    GlobalKey<FormState>? formKeyLogin,
    BlocFormItem? email,
    BlocFormItem? password,
    Resource? response,
  }) {
    return LoginState(
      // Set the data that the user uploads. In case of null, I assign the default value
      formKeyLogin: formKeyLogin,
      email: email ?? this.email,
      password: password ?? this.password,
      response: response
    );
  }

  // props - We specify the variables that change state
  @override
  List<Object?> get props => [email, password, response];

}