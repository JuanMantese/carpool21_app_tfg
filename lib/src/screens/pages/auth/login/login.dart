import 'package:another_flushbar/flushbar.dart';
import 'package:carpool_21_app/src/domain/models/authResponse.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/bloc/loginBloc.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/bloc/loginEvent.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/bloc/loginState.dart';
import 'package:carpool_21_app/src/screens/pages/auth/login/loginContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // User Screen
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final response = state.response;
          if (response is ErrorData) {
            print('Error Data: ${response.message}');
            Fluttertoast.showToast(
              msg: response.message, 
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 2,
              textColor: Colors.white,
              fontSize: 16.0
            ); 
          } else if (response is Success) {
            print('Success Data: ${response.data}');
            final authResponse = response.data as AuthResponse;
            context.read<LoginBloc>().add(SaveUserSession(authResponse: authResponse));

            if (authResponse.user!.roles!.length > 1) {
              // Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
              // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (route) => false);
              context.go('/passenger/0');
            }
            else {
              // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (route) => false);
              context.go('/passenger/0');
            }

            // Mostrar mensaje de éxito
            // showCustomFlushbar(context);

            Fluttertoast.showToast(
              msg: 'Login exitoso', 
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 2,
              backgroundColor: const Color.fromARGB(255, 45, 139, 48),
              textColor: Colors.white,
              fontSize: 16.0
            ); 
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final response = state.response;
            if (response is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return LoginContent(state);
          },
        ),
      )
    );
  }

  // Alert / Dialog / Custom Alert
  void showCustomFlushbar(BuildContext context) {
    Flushbar(
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(10),
 
      backgroundGradient: LinearGradient(
        colors: [
          Colors.pink.shade500,
          Colors.pink.shade300,
          Colors.pink.shade100
        ],
        stops: const [0.4, 0.7, 1],
      ),
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      // title: 'Login exitoso',
      message: 'Welcome to Flutter community.',
      messageSize: 17,
    ).show(context);
  }
}
