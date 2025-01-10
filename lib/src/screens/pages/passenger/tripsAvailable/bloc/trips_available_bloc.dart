// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/drivers_position_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsAvailableBloc extends Bloc<TripsAvailableEvent, TripsAvailableState> {

  AuthUseCases authUseCases;
  DriversPositionUseCases driversPositionUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;

  TripsAvailableBloc(
    this.authUseCases,
    this.driversPositionUseCases,
    this.driverTripRequestsUseCases,
    this.socketUseCases, 
    this.socketIOBloc
  ): super(
    TripsAvailableState(
      response: Loading(), // Estado inicial como Loading
      availableTrips: null, // Inicialmente no hay viajes disponibles
      showNewTripsAvailable: false, // Inicialmente no hay nuevos viajes que informar
    )
  ) {

    on<GetTripsAvailable>((event, emit) async {
      print('GetTripsAvailable ---------------------');
      print('Estado actual antes de actualizar: ${state.availableTrips}');

      emit(
        state.copyWith(
          response: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el resultado
      Resource<List<TripDetail>> availableTripsRes = await driverTripRequestsUseCases.getAllTripsUseCase.run();

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          response: availableTripsRes,
          showNewTripsAvailable: false,
        ),
      );

      if (availableTripsRes is Success<List<TripDetail>>) {
        print('Estado actualizado con viajes disponibles: ${availableTripsRes.data}');

        // Ejecutamos el evento para escuchar los cambios por Socket.IO
        add(ListenTripsAvailablesSocketIO());

      } else if (availableTripsRes is ErrorData<List<TripDetail>>) {
        print('Error al obtener los viajes: ${availableTripsRes.message}');
      }
    });

    // Escuchamos las nuevas ofertas de Viajes disponibles
    on<ListenTripsAvailablesSocketIO>((event, emit) async {
      print('Escuchando nuevas ofertas de viajes disponibles >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(socketIOBloc.state.socket);
      print(socketIOBloc.state.socket?.connected);

      if (socketIOBloc.state.socket != null && socketIOBloc.state.socket!.connected) {
        // Creamos un StreamController para gestionar la emisión
        final controller = StreamController<void>();
        
        socketIOBloc.state.socket?.on('created_trip_notification', (data) async {
          print('Obteniendo el Nuevo Viaje Creado - Socket IO');
          print(data);

          // Actualizando la pantalla con los viajes disponibles 
          // No la utilizo porque es contraproducente para la experiencia del usuario
          // add(GetTripsAvailable());
          // ---------------------------------------------------

          // Habilitando el mensaje de nuevos viajes disponibles
          emit(state.copyWith(
            showNewTripsAvailable: true, 
          ));

          // Cuando el evento se haya procesado, cerramos el controller
          controller.add(null);
        });

        // Esperar a que el evento se haya completado
        await controller.stream.first;
        await controller.close();
      }
    });

    on<GetNearbyTripRequest>((event, emit) async {
      // AuthResponse authResponse = await authUseCases.getUserSession.run();
      // Resource driverPositionResponse = await driversPositionUseCases.getDriverPosition.run(authResponse.user.id ?? 1);

      // emit(
      //   state.copyWith(
      //     response: Loading(),
      //   )
      // );

      // if (driverPositionResponse is Success) {
      //   final driverPosition = driverPositionResponse.data as DriverPosition;
      //   Resource<List<PassengerRequest>> response = await passengerRequestsUseCases.getNearbyTripRequestUseCase.run(driverPosition.lat, driverPosition.lng);
      //   emit(
      //     state.copyWith(
      //       response: response,
      //     )
      //   );
      // }
    });
  }
}