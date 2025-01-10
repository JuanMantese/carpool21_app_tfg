import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/trips_available_content.dart';
import 'package:carpool_21_app/src/screens/widgets/search_advanced.dart';
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

  // void _filterTrips(String query, List<TripDetail> requests) {
  //   setState(() {
  //     filteredRequests = requests.where((request) {
  //       return request.pickupNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
  //              request.pickupText.toLowerCase().contains(query.toLowerCase()) ||
  //              request.destinationNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
  //              request.destinationText.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }

  List<TripDetail> _filterTrips(String query, List<TripDetail> requests) {
    return requests.where((request) {
      return request.pickupNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
            request.pickupText.toLowerCase().contains(query.toLowerCase()) ||
            request.destinationNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
            request.destinationText.toLowerCase().contains(query.toLowerCase());
    }).toList();
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

          // Estado de éxito
          else if (response is Success<List<TripDetail>>) {
            final availableTrips = response.data;

            // Mostrar un mensaje si no hay viajes disponibles
            if (availableTrips.isEmpty) {
              return const Center(
                child: Text(
                  'No hay viajes disponibles.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Sincronizamos la lista filtrada
            filteredRequests = searchController.text.isEmpty
              ? availableTrips
              : _filterTrips(searchController.text, availableTrips);

            return TripsAvailableContent(
              state,
              passengerRequests: availableTrips,
              filteredRequests: filteredRequests,
              searchController: searchController,
              onSearch: (query) => _filterTrips(query, availableTrips),
              onShowAdvancedOptions: () => _showAdvancedOptionsModal(context),
            );
          }

          else if (response is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.message)),
              );
              Navigator.of(context).pop(); // Redirige al Home
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige

            //  Fluttertoast.showToast(
            //   msg: response.message, 
            //   toastLength: Toast.LENGTH_LONG
            // ); 
          }

          else {
            return Container(
              child: const Text('Error interno en TripsAvailable')
            );
          }
        },
      ),
    );
  }
}