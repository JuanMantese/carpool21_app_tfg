import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/registerBloc.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/registerEvent.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/registerState.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/registerContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {

    // Register User Screen
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          final response = state.response;
          if (response is ErrorData) {
            Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_LONG); 
            print('Error Data: ${response.message}');
            
          } else if (response is Success) {
            // Inicio de sesion automatico - No pasa por el Login
            // final authResponse = response.data as AuthResponse;
            // context.read<RegisterBloc>().add(SaveUserSession(authResponse: authResponse));
            // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (route) => false);

            // Envio al Login
            // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            context.pop();
            Fluttertoast.showToast(msg: 'Registro exitoso', toastLength: Toast.LENGTH_LONG); 
            print('Success Data: ${response.data}');

            // Form Reload
            // context.read<RegisterBloc>().add(FormReset());
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return RegisterContent(state);
          },
        ),
      ),
    );
  }
}
