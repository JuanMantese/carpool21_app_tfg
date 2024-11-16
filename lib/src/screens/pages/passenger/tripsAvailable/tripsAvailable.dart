import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableBloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableState.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/tripsAvailableContent.dart';
import 'package:carpool_21_app/src/screens/widgets/SearchAdvanced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TripsAvailablePage extends StatefulWidget {
  const TripsAvailablePage({super.key});

  @override
  State<TripsAvailablePage> createState() => _TripsAvailablePageState();
}

class _TripsAvailablePageState extends State<TripsAvailablePage> {
  TextEditingController searchController = TextEditingController();
  List<TripDetail> filteredRequests = [];
  List<TripDetail> passengerRequests = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<TripsAvailableBloc>().add(GetNearbyTripRequest(driverLat: -31.322187, driverLng: -64.2219203));
      context.read<TripsAvailableBloc>().add(GetTripsAvailable());
    });
  }

  void _filterTrips(String query, List<TripDetail> requests) {
    setState(() {
      filteredRequests = requests.where((request) {
        return request.pickupNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
               request.pickupText.toLowerCase().contains(query.toLowerCase()) ||
               request.destinationNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
               request.destinationText.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // NUEVA OPCION DE FILTRO QUE INCLUIRIA LOS FILTROS AVANZADOS
  // void _filterTrips(String query) {
  //   setState(() {
  //     filteredRequests = passengerRequests.where((request) {
  //       return request.pickupText.toLowerCase().contains(query.toLowerCase()) ||
  //              request.destinationText.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }

   void _applyFilters(String originDestination, String campus, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      filteredRequests = passengerRequests.where((request) {
        bool matchesOriginDestination = true;
        bool matchesCampus = true;
        bool matchesTime = true;

        if (originDestination != 'Origen/Destino') {
          if (originDestination == 'Origen') {
            matchesOriginDestination = request.pickupText.contains(campus);
          } else if (originDestination == 'Destino') {
            matchesOriginDestination = request.destinationText.contains(campus);
          }
        }

        if (campus != 'Sedes') {
          matchesCampus = request.pickupText.contains(campus) || request.destinationText.contains(campus);
        }

        final requestTime = TimeOfDay.fromDateTime(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(request.departureTime));
        final startMinutes = startTime.hour * 60 + startTime.minute;
        final endMinutes = endTime.hour * 60 + endTime.minute;
        final requestMinutes = requestTime.hour * 60 + requestTime.minute;

        matchesTime = requestMinutes >= startMinutes && requestMinutes <= endMinutes;

        return matchesOriginDestination && matchesCampus && matchesTime;
      }).toList();
    });
  }

  void _showAdvancedOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AdvancedFiltersModal(
          onFilter: (originDestination, campus, startTime, endTime) {
            _applyFilters(originDestination, campus, startTime, endTime);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TripsAvailableBloc, TripsAvailableState>(
        builder: (context, state) {
          final response = state.response;

          if (response is Loading) {
            return const Center(child: CircularProgressIndicator());
          } 
          // MEJORAR ESTA LOGICA - Debo cambiar como recibo los datos, para que en ves de recibir Success reciba Resource y ahi trabajarlo
          // else if (response is Success) {
          //   List<TripDetail> passengerRequests = response.data as List<TripDetail>;
            
          //   if (filteredRequests.isEmpty && searchController.text.isEmpty) {
          //     filteredRequests = passengerRequests;
          //   }
            
          //   return TripsAvailableContent(
          //     state, 
          //     passengerRequests: passengerRequests,
          //     filteredRequests: filteredRequests,
          //     searchController: searchController,
          //     onSearch: (query) => _filterTrips(query, passengerRequests),
          //     // onSearch: _filterTrips,
          //     onShowAdvancedOptions: () => _showAdvancedOptionsModal(context),
          //   );
          // }
          // NO SE ELIMINA ESTO

          else if (state.availableTrips?.length != null) {
            if (filteredRequests.isEmpty && searchController.text.isEmpty) {
              filteredRequests = state.availableTrips!;
            }
            
            return TripsAvailableContent(
              state, 
              passengerRequests: state.availableTrips!,
              filteredRequests: filteredRequests,
              searchController: searchController,
              onSearch: (query) => _filterTrips(query, state.availableTrips!),
              // onSearch: _filterTrips,
              onShowAdvancedOptions: () => _showAdvancedOptionsModal(context),
            );
          }

          // DELETE - Utilizamos este ARRAY de prueba
          // if (state.availableTrips != null) {
          //   List<TripDetail> passengerRequestTest = state.availableTrips!;

          //   if (filteredRequests.isEmpty && searchController.text.isEmpty) {
          //     filteredRequests = passengerRequestTest;
          //   }

          //   return TripsAvailableContent(
          //     state, 
          //     passengerRequests: passengerRequestTest,
          //     filteredRequests: filteredRequests,
          //     searchController: searchController,
          //     onSearch: (query) => _filterTrips(query, passengerRequestTest),
          //     // onSearch: _filterTrips,
          //     onShowAdvancedOptions: () => _showAdvancedOptionsModal(context),
          //   );

          else {
            return Container(
              child: Text('No logramos entrar')
            );
          }
        },
      ),
    );
  }
}