// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/driver_trip_request.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/car_info_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_trip_event.dart';
import 'create_trip_state.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  SocketIOBloc socketIOBloc;

  CreateTripBloc(
    this.authUseCases, 
    this.carInfoUseCases, 
    this.driverTripRequestsUseCases, 
    this.socketIOBloc
  ) : super(
    CreateTripState(
      pickUpNeighborhood: '',
      pickUpText: '',
      pickUpLatLng: null,
      destinationNeighborhood: '',
      destinationText: '',
      destinationLatLng: null,
      departureTime: null,
      timeAndDistanceValues: TimeAndDistanceValues(
        distance: Distance(text: "", value: 0.0),
        duration: Duration(text: "", value: 0.0),
      ),
      responseDriverTripRequest: null,
      responseVehicleList: Loading()
    )
  ) {

    on<InitializeTrip>((event, emit) async {
      print('Entramos a InitializeTrip ------------------------------');
      Resource<List<CarInfo>> vehicleListRes = await carInfoUseCases.getCarList.run();

      emit(
        state.copyWith(
          neighborhoodPreSelected: event.pickUpNeighborhood == '' ? 'destinationNeighborhood' : 'pickUpNeighborhood', 
          pickUpNeighborhood: event.pickUpNeighborhood,
          pickUpText: event.pickUpText,
          pickUpLatLng: event.pickUpLatLng,
          destinationNeighborhood: event.destinationNeighborhood,
          destinationText: event.destinationText,
          destinationLatLng: event.destinationLatLng,
          departureTime: event.departureTime,
          timeAndDistanceValues: event.timeAndDistanceValues,
          responseVehicleList: vehicleListRes,
        )
      );
    });

    on<UpdateNeighborhood>((event, emit) {
      if (state.neighborhoodPreSelected == 'pickUpNeighborhood') {
        emit(state.copyWith(destinationNeighborhood: event.neighborhood));
      } else {
        emit(state.copyWith(pickUpNeighborhood: event.neighborhood));
      }
    });

    on<UpdateVehicle>((event, emit) {
      emit(state.copyWith(selectedVehicle: event.vehicle));
    });

    on<UpdateAvailableSeats>((event, emit) {
      emit(state.copyWith(availableSeats: event.seats));
    });

    on<UpdateTripObservations>((event, emit) {
      emit(state.copyWith(tripObservations: event.tripObservationsInput));
    });


    // Creando un viaje
    on<CreateTripRequest>((event, emit) async {
      print('Creando Viaje');
      print(state.pickUpNeighborhood);
      print(state.pickUpText);
      print(state.pickUpLatLng!.latitude);
      print(state.pickUpLatLng!.longitude);
      print(state.destinationNeighborhood);
      print(state.destinationText);
      print(state.destinationLatLng!.latitude);
      print(state.destinationLatLng!.longitude);
      print('Departure Time: ${state.departureTime}');
      print('Vehiculo: ${state.selectedVehicle}');
      print('Asientos: ${state.availableSeats}');
      print('Observaciones: ${state.tripObservations}');

      Success<TripDetail> response = await driverTripRequestsUseCases.createTripRequestUseCase.run(
        DriverTripRequest(
          vehicleId: state.selectedVehicle!,
          pickupNeighborhood: state.pickUpNeighborhood,
          pickupText: state.pickUpText, 
          pickupLat: state.pickUpLatLng!.latitude, 
          pickupLng: state.pickUpLatLng!.longitude, 
          destinationNeighborhood: state.destinationNeighborhood,
          destinationText: state.destinationText, 
          destinationLat: state.destinationLatLng!.latitude, 
          destinationLng: state.destinationLatLng!.longitude,
          availableSeats: state.availableSeats!,
          departureTime: state.departureTime!, // '2024-07-06T21:00:00Z' Format
          // compensation: 1000,
          observations: state.tripObservations
        )
      );
      // departureTime: state.departureTime!,
      print(response);
      // Traigo la respuesta que me devuelve el Back al crear un viaje
      emit(
        state.copyWith(
          responseDriverTripRequest: response
        )
      );
    });

    // Informando de los nuevos viajes disponibles
    on<EmitNewTripRequestSocketIO>((event, emit) {
      print('Emitiendo la creación de un nuevo viaje >>>>>>>>>>>>>>>>>>>>>');

      if(socketIOBloc.state.socket != null) {
        socketIOBloc.state.socket?.emit('new_trip_offer', {
          'id_driver_request': 12
        });
      }
    });

    // Reseteo los valores del State al ejecutar una creación de viaje Exitosamente
    on<ResetState>((event, emit) {
      print('reseteo');
      emit(CreateTripState(
        pickUpNeighborhood: '',
        pickUpText: '',
        pickUpLatLng: null,
        destinationNeighborhood: '',
        destinationText: '',
        destinationLatLng: null,
        departureTime: null,
        timeAndDistanceValues: TimeAndDistanceValues(
          distance: Distance(text: "", value: 0.0),
          duration: Duration(text: "", value: 0.0),
        ),
      )); // Emitimos el estado inicial limpio.
    });
  }
}