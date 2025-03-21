import 'package:carpool_21_app/config/router/app_router.dart';
import 'package:carpool_21_app/src/data/dataSource/remote/services/users_service.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_event.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/home/bloc/passenger_home_view_state.dart';
import 'package:carpool_21_app/src/views/passenger/home/passenger_home_content.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_bloc.dart';
import 'package:carpool_21_app/src/views/passenger/reserves/bloc/reserves_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class PassengerHomeView extends StatefulWidget {
  const PassengerHomeView({super.key});

  @override
  State<PassengerHomeView> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHomeView>
  with RouteAware, AutomaticKeepAliveClientMixin {
  // Obtén la instancia de UsersService
  UsersService userService = GetIt.instance<UsersService>();

  late PassengerHomeViewBloc passengerHomeViewBloc;

  @override
  void initState() {
    super.initState();

    passengerHomeViewBloc = context.read<PassengerHomeViewBloc>(); 

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

    return MultiBlocListener(
      listeners: [
        BlocListener<ReservesBloc, ReservesState>(
          listener: (context, state) {
            final cancelReserveDetail = state.cancelationReserveRes;

            if (cancelReserveDetail is Loading) {
              // TODO: Loading
            }

            // Success Status
            else if (cancelReserveDetail is Success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, 'Volvé a reservar tu próximo viaje con nosotros',
                  customTitle: 'Reserva cancelada exitosamente',
                  type: AlertType.success
                );
              });

              // Si la reserva se canceló con éxito, volvemos a obtener las reservas
              context.read<PassengerHomeViewBloc>().add(GetCurrentReserve());
            }

            // Error Status
            else if (cancelReserveDetail is ErrorData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, cancelReserveDetail.message,
                  customTitle: 'Error al cancelar la reserva',
                  type: AlertType.error
                );
              });
            }
          },
        ),
        BlocListener<PassengerHomeViewBloc, PassengerHomeViewState>(
          listener: (context, state) {
            if (state.startTrip) {
              context.read<PassengerHomeViewBloc>().add(ResetState());

              final resReserveDetail = state.reservesAll?.futureReservations[0];

              context.push('/passenger/0/reserve/mapTripPassenger', extra: {
                'idReserve': resReserveDetail!.idReservation
              });
            }
          },
        ),
      ],
      child: BlocBuilder<PassengerHomeViewBloc, PassengerHomeViewState>(
        builder: (context, state) {
          switch (state.responseStatus) {
            case PassengerHomeViewStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PassengerHomeViewStatus.success:
              return Scaffold(
                body: PassengerHomeContent(state: state),
              );
            case PassengerHomeViewStatus.error:
              print(state.responseStatus);
              return Scaffold(
                body: Center(
                  child: Text(state.errorMessage ?? 'Error desconocido')
                ),
              );
            default:
              print(state.responseStatus);
              return Scaffold(
                body: Center(
                  child: Text(state.errorMessage ?? 'Error desconocido - Default')
                ),
              );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
