import 'package:bloc/bloc.dart';
import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/driverTripRequest.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/authUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/car-info/carInfoUseCases.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driverTripRequestUseCases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'createTripEvent.dart';
import 'createTripState.dart';

class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {

  AuthUseCases authUseCases;
  CarInfoUseCases carInfoUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;

  CreateTripBloc(this.authUseCases, this.carInfoUseCases, this.driverTripRequestsUseCases) : super(
    CreateTripState(
      pickUpNeighborhood: '',
      pickUpText: '',
      pickUpLatLng: null,
      destinationNeighborhood: '',
      destinationText: '',
      destinationLatLng: null,
      departureTime: null,
      timeAndDistanceValues: TimeAndDistanceValues(
        tripPrice: 1000.0,
        distance: Distance(text: "", value: 0.0),
        duration: Duration(text: "", value: 0.0),
      ),
      state: DriverMapBookingInfoState(),
    )
  ) {

    on<InitializeTrip>((event, emit) async {
      print('Entramos a InitializeTrip ------------------------------');
      Resource<List<CarInfo>> response = await carInfoUseCases.getCarList.run();

      if (response is Success<List<CarInfo>>) {
        print('Seteando valores iniciales');
        final vehicles = response.data;

        emit(state.copyWith(
          neighborhoodPreSelected: event.pickUpNeighborhood == '' ? 'destinationNeighborhood' : 'pickUpNeighborhood', 
          pickUpNeighborhood: event.pickUpNeighborhood,
          pickUpText: event.pickUpText,
          pickUpLatLng: event.pickUpLatLng,
          destinationNeighborhood: event.destinationNeighborhood,
          destinationText: event.destinationText,
          destinationLatLng: event.destinationLatLng,
          departureTime: event.departureTime,
          timeAndDistanceValues: event.timeAndDistanceValues,
          vehicleList: vehicles,
          state: event.state,
        ));
      } else if (response is Error) {
        // Maneja el error adecuadamente
        print('Error al cargar la lista de vehículos: ${response}');
      } else {
        // Maneja cualquier otro estado, si es necesario
      }

      // emit(state.copyWith(
      //   pickUpText: event.pickUpText,
      //   pickUpLatLng: event.pickUpLatLng,
      //   destinationText: event.destinationText,
      //   destinationLatLng: event.destinationLatLng,
      //   timeAndDistanceValues: event.timeAndDistanceValues,
      //   vehicleList: vehicles,
      //   state: event.state,
      // ));
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
  }
}