// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/bloc/register_state.dart';
import 'package:carpool_21_app/src/screens/pages/auth/register/register_content.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          final userRegisterRes = state.response;

          if (userRegisterRes is Success) {
            print('Success Data: ${userRegisterRes.data}');

            // Registro Exitoso - Inicio de sesion automatico - No pasa por el Login
            // final authResponse = response.data as AuthResponse;
            // context.read<RegisterBloc>().add(SaveUserSession(authResponse: authResponse));
            // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (route) => false);

            // Registro Exitoso - Envío al Login
            context.pop();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showOverlayMessage(
                context, 
                'Inicia sesión y comenzá a utilizar la app',
                customTitle: 'Registro exitoso',
                type: AlertType.success
              );
            });
            
            // Form Reload
            // context.read<RegisterBloc>().add(FormReset());
          } 
          
          else if (userRegisterRes is ErrorData) {
            print('Error Data: ${userRegisterRes.message}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showOverlayMessage(
                context, 
                userRegisterRes.message,
                customTitle: 'Error al registrar el usuario',
                type: AlertType.error
              );
            });
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            final userRegisterRes = state.response;

            // We display the content and the Loading
            if (userRegisterRes is Loading) {
              return Stack(
                children: [
                  RegisterContent(state),
                  const Center(child: CircularProgressIndicator())
                ],
              );
            } 

            return RegisterContent(state);
          },
        ),
      ),
    );
  }
}
