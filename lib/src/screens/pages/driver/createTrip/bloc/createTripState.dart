import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTripState extends Equatable {
  final String? neighborhoodPreSelected; // Barrio pre-seleccionado segun la sede elegida 
  final String? tripObservations; // Descripción opcional del viaje  
  final int? selectedVehicle;
  final int? availableSeats;
  final String pickUpNeighborhood;
  final String pickUpText;
  final LatLng? pickUpLatLng;
  final String destinationNeighborhood;
  final String destinationText;
  final LatLng? destinationLatLng;
  final String? departureTime;
  final TimeAndDistanceValues timeAndDistanceValues;
  final Resource? responseDriverTripRequest;
  
  final List<CarInfo>? vehicleList;
  
  final DriverMapBookingInfoState state;


  CreateTripState({
    this.neighborhoodPreSelected,
    this.tripObservations,
    this.selectedVehicle,
    this.availableSeats,
    this.departureTime,
    this.pickUpNeighborhood = '',
    required this.pickUpText,
    required this.pickUpLatLng,
    this.destinationNeighborhood = '',
    required this.destinationText,
    required this.destinationLatLng,
    required this.timeAndDistanceValues,
    this.responseDriverTripRequest,
    this.vehicleList,
    required this.state,
  });

  CreateTripState copyWith({
    String? neighborhoodPreSelected,
    String? tripObservations,
    int? selectedVehicle,
    int? availableSeats,
    String? departureTime,
    String? pickUpNeighborhood,
    String? pickUpText,
    LatLng? pickUpLatLng,
    String? destinationNeighborhood,
    String? destinationText,
    LatLng? destinationLatLng,
    TimeAndDistanceValues? timeAndDistanceValues,
    Resource? responseDriverTripRequest,
    List<CarInfo>? vehicleList,
    DriverMapBookingInfoState? state,
  }) {
    return CreateTripState(
      neighborhoodPreSelected: neighborhoodPreSelected ?? this.neighborhoodPreSelected,
      tripObservations: tripObservations ?? this.tripObservations,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      availableSeats: availableSeats ?? this.availableSeats,
      departureTime: departureTime ?? this.departureTime,
      pickUpNeighborhood: pickUpNeighborhood ?? this.pickUpNeighborhood,
      pickUpText: pickUpText ?? this.pickUpText,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationNeighborhood: destinationNeighborhood ?? this.destinationNeighborhood,
      destinationText: destinationText ?? this.destinationText,
      destinationLatLng: destinationLatLng ?? this.destinationLatLng,
      timeAndDistanceValues: timeAndDistanceValues ?? this.timeAndDistanceValues,
      responseDriverTripRequest: responseDriverTripRequest ?? this.responseDriverTripRequest,
      vehicleList: vehicleList ?? this.vehicleList,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
    neighborhoodPreSelected,
    tripObservations,
    selectedVehicle,
    availableSeats,
    departureTime,
    pickUpNeighborhood,
    pickUpText,
    pickUpLatLng,
    destinationNeighborhood,
    destinationText,
    destinationLatLng,
    timeAndDistanceValues,
    responseDriverTripRequest,
    state,
  ];
}