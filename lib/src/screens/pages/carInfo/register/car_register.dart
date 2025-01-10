// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_state.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/car_register_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CarRegisterPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const CarRegisterPage({
    super.key,
    required this.arguments
  });

  @override
  State<CarRegisterPage> createState() => _CarRegisterPageState();
}

class _CarRegisterPageState extends State<CarRegisterPage> with RouteAware {
  late String previousRoute;

  // Initial execution - First event to fire when the screen first appears - Runs only once
  @override
  void initState() {
    super.initState();

    // Recibiendo los argumentos del Vehiculo
    final args = widget.arguments;

    previousRoute = args['originPage'];

    // Wait until all elements of the Widget build are loaded to execute the Event
    // This is done to prevent the carInfo from coming in as null, as it is instantiated in the Widget build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CarRegisterBloc>().add(CarRegisterInitEvent());
    });
  }

  // Secondary execution: Triggered every time we make a state change in a widget on that screen
  @override
  Widget build(BuildContext context) {
    print('Previous Route: $previousRoute');

    return Scaffold(
      body: BlocListener<CarRegisterBloc, CarRegisterState>(
        listener: (context, state) {
          final carRegisterRes = state.response; 
          
          if (carRegisterRes is Success) {
            print('Success Data: ${carRegisterRes.data}');

            CarInfo carInfo = carRegisterRes.data;
            
            // Actualizamos la información local del usuario
            context.read<CarRegisterBloc>().add(UpdateUserSession());

            // Navigator.pushNamedAndRemoveUntil(context, '/car/info', (route) => false,
            //   arguments: {
            //     'idVehicle': carInfo.idVehicle,
            //     'originPage': previousRoute
            //   }
            // );

            context.go('/car/list/info', extra: {
              'idVehicle': carInfo.idVehicle,
              'originPage': previousRoute
            });

            Fluttertoast.showToast(msg: 'Registro exitoso', toastLength: Toast.LENGTH_LONG); 
          }

          else if (carRegisterRes is ErrorData) {
            // Muestra un mensaje de Error
            Fluttertoast.showToast(
              msg: 'Error al realizar la reserva: ${carRegisterRes.message}',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<CarRegisterBloc, CarRegisterState>(
          builder: (context, state) {
            final response = state.response;

            // We display the content and the Loading
            if (response is Loading) {
              return Stack(
                children: [
                  CarRegisterContent(state),
                  const Center(child: CircularProgressIndicator())
                ],
              );
            } 

            return CarRegisterContent(state);
          },
        ),
      ),
    );
  }
}
