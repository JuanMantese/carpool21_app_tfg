import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/bloc/reserve_detail_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/reserveDetail/reserve_detail_content.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReserveDetailPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const ReserveDetailPage({
    super.key,
    required this.arguments
  });

  @override
  State<ReserveDetailPage> createState() => _ReserveDetailPageState();
}

class _ReserveDetailPageState extends State<ReserveDetailPage> {
  
  late int idReserve;
  late ReserveDetailBloc reserveDetailBloc;
  
  @override
  void initState() {
    super.initState();

    // Referencia al Bloc del ReserveDetail
    reserveDetailBloc = context.read<ReserveDetailBloc>();

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo el Id de la reserva
      final args = widget.arguments;

      idReserve = args['idReserve'];

      context.read<ReserveDetailBloc>().add(GetReserveDetail(idReserve: idReserve));
    });
  }

  @override
  void dispose() {
    // Usa la referencia guardada para ejecutar el evento ResetState
    reserveDetailBloc.add(ResetState());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ReserveDetailBloc, ReserveDetailState>(
        builder: (context, state) {
          final responseReserveDetail = state.responseGetReserve;
          final cancelReserveDetail = state.cancelationReserveRes;

          if (responseReserveDetail is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Success Status 
          else if (responseReserveDetail is Success) {
            final reserveDetail = responseReserveDetail.data;

            if (cancelReserveDetail is Loading) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (cancelReserveDetail is Success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, 
                  'Volvé a reservar tu próximo viaje con nosotros',
                  customTitle: 'Reserva cancelada exitosamente',
                  type: AlertType.success
                );
              });

              // Redirige al Home después de mostrar el mensaje
              Future.microtask(() => context.pop());
            } 
            else if (cancelReserveDetail is ErrorData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, 
                  cancelReserveDetail.message,
                  customTitle: 'Error al cancelar la reserva',
                  type: AlertType.error
                );
              });
            }

            return ReserveDetailContent(
              reserveDetail, 
              state,
            );
          }

          // Error Status
          else if (responseReserveDetail is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showOverlayMessage(
                  context, 
                  responseReserveDetail.message,
                  customTitle: 'Error al obtener la reserva',
                  type: AlertType.error
                );
              });
              context.pop(); // Redirige al Home
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
          }

          else {
            return const Center(
              child: Text('Error interno en ReserveDetail')
            );
          }
        }
      ),
    );
  }
}