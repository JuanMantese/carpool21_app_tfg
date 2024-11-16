import 'package:carpool_21_app/config/router/app_router.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_event.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_state.dart';
import 'package:carpool_21_app/src/views/passenger/home/passenger_home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PassengerHomeView extends StatefulWidget {
  const PassengerHomeView({super.key});

  @override
  State<PassengerHomeView> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHomeView> with RouteAware, AutomaticKeepAliveClientMixin {
  // Obtén la instancia de UsersService
  UsersService userService = GetIt.instance<UsersService>();
  
  @override
  void initState() {
    super.initState();

    // Dispara el evento para obtener la información del pasajero
    context.read<PassengerHomeViewBloc>().add(GetUserInfo(userService));

    // Dispara el evento para obtener la reserva del pasajero
    context.read<PassengerHomeViewBloc>().add(GetCurrentReserve());
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
    context.read<PassengerHomeViewBloc>().add(GetUserInfo(userService));
    context.read<PassengerHomeViewBloc>().add(GetCurrentReserve());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Le dice al view como fue construido originalmente el widget para preservarlo

    return BlocBuilder<PassengerHomeViewBloc, PassengerHomeViewState>(
      builder: (context, state) {
        switch (state.responseStatus) {
          case PassengerHomeViewStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PassengerHomeViewStatus.success:
            return Scaffold(
              body: PassengerHomeContent(state: state),
            );
          case PassengerHomeViewStatus.error:
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

  @override
  bool get wantKeepAlive => true;
}
