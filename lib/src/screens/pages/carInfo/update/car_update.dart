import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/car_update_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/car_update_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/car_update_state.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/car_update_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CarUpdatePage extends StatefulWidget {
  final CarInfo? car;

  const CarUpdatePage({
    super.key,
    this.car
  });

  @override
  State<CarUpdatePage> createState() => _CarUpdatePageState();
}

class _CarUpdatePageState extends State<CarUpdatePage> {
  CarInfo? car;

  // Initial execution - First event to fire when the screen first appears - Runs only once
  @override
  void initState() {
    super.initState();

    // Asigna el valor de car desde el widget
    car = widget.car;

    // Wait until all elements of the Widget build are loaded to execute the Event
    // This is done to prevent the user from coming in as null, as it is instantiated in the Widget build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CarUpdateBloc>().add(CarUpdateInitEvent(car: car));
    });
  }

  // Secondary execution: Triggered every time we make a state change in a widget on that screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CarUpdateBloc, CarUpdateState>(
        listener: (context, state) {
          final carUpdateRes = state.response;

          if (carUpdateRes is Success) {
            print('Success Data: ${carUpdateRes.data}');

            // Updating the data of the user in session
            // User user = response.data as User;
            // context.read<CarUpdateBloc>().add(UpdateUserSession(user: user));

            // Updating car info data on screen - I wait 1s for the in-session update to finish
            Future.delayed(const Duration(seconds: 1), () {
              // context.read<CarUpdateBloc>().add(GetUserInfo());
            });

            // Navigator.pop(context);
            context.pop();

            Fluttertoast.showToast(msg: 'Actualizacion exitosa', toastLength: Toast.LENGTH_LONG); 
          } 

          else if (carUpdateRes is ErrorData) {
            // Muestra un mensaje de Error
            Fluttertoast.showToast(
              msg: 'Error al actualizar el vehiculo: ${carUpdateRes.message}',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<CarUpdateBloc, CarUpdateState>(
          builder: (context, state) {
            final carUpdateRes = state.response; 
            
            // We display the content and the Loading
            if (carUpdateRes is Loading) {
              return Stack(
                children: [
                  CarUpdateContent(car, state),
                  const Center(child: CircularProgressIndicator())
                ],
              );
            } 

            return CarUpdateContent(car, state);
          },
        ),
      ),
    );
  }
}
