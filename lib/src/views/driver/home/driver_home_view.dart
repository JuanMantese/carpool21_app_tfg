import 'package:carpool_21_app/config/router/app_router.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_bloc.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_event.dart';
import 'package:carpool_21_app/src/views/driver/home/bloc/driver_home_view_state.dart';
import 'package:carpool_21_app/src/views/driver/home/driver_home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart' as globals;

class DriverHomeView extends StatefulWidget {
  const DriverHomeView({super.key});

  @override
  State<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> with RouteAware {
  // Obtén la instancia de UsersService
  UsersService userService = GetIt.instance<UsersService>();
  
  @override
  void initState() {
    super.initState();

    // Dispara el evento para obtener la información del usuario
    context.read<DriverHomeViewBloc>().add(GetUserInfo(userService));
    globals.currentRole = 'driver';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registra la pantalla como RouteAware si es una instancia de PageRoute
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    // Anula la suscripción cuando se destruya la pantalla
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Se ejecuta cuando se regresa a esta pantalla
    context.read<DriverHomeViewBloc>().add(GetUserInfo(userService));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverHomeViewBloc, DriverHomeViewState>(
      builder: (context, state) {
        switch (state.responseStatus) {
          case DriverHomeViewStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case DriverHomeViewStatus.success:
            return Scaffold(
              body: DriverHomeContent(state: state),
            );
          case DriverHomeViewStatus.error:
            return Scaffold(
              body: Center(child: Text(state.errorMessage ?? 'Error desconocido')),
            );
          default:
            return Scaffold(
              body: Center(child: Text(state.errorMessage ?? 'Error desconocido - Default')),
            );
        }
      },
    );
  }
}