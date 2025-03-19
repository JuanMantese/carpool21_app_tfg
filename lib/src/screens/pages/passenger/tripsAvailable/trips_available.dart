// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/trips_available_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/trips_available_content.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:carpool_21_app/src/screens/widgets/search_advanced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TripsAvailablePage extends StatefulWidget {
  const TripsAvailablePage({super.key});

  @override
  State<TripsAvailablePage> createState() => _TripsAvailablePageState();
}

class _TripsAvailablePageState extends State<TripsAvailablePage> {
  TextEditingController searchController = TextEditingController();
  List<TripDetail> filteredRequests = [];

  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<TripsAvailableBloc>().add(GetNearbyTripRequest(driverLat: -31.322187, driverLng: -64.2219203));
      context.read<TripsAvailableBloc>().add(GetTripsAvailable());
    });
  }

  void _filterTrips(String query, List<TripDetail> requests) {
    print('Buscador - filter Trips $query');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredRequests = requests.where((request) {       
          return request.pickupNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
                request.pickupText.toLowerCase().contains(query.toLowerCase()) ||
                request.destinationNeighborhood.toLowerCase().contains(query.toLowerCase()) ||
                request.destinationText.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
    print('Filtered Requests: ${filteredRequests.length}');
  }

  void _applyFilters(String originDestination, String campus, TimeOfDay startTime, TimeOfDay endTime, List<TripDetail> requests) {
    print('Aplicando filtros: $originDestination, $campus, $startTime - $endTime');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
          filteredRequests = requests.where((request) {
            bool matchesOriginDestination = true;
            bool matchesTime = true;

            // 🎯 Filtro por Origen/Destino
            if (originDestination != 'Origen/Destino') {
              if (originDestination == 'Origen') {
                matchesOriginDestination = request.pickupNeighborhood.toLowerCase().contains(campus.toLowerCase());
              } else if (originDestination == 'Destino') {
                matchesOriginDestination = request.destinationNeighborhood.toLowerCase().contains(campus.toLowerCase());
              }
            } else {
              // 🎯 Filtro solo por el Campus
              if (campus != 'ALL') {    
                matchesOriginDestination = request.pickupNeighborhood.toLowerCase().contains(campus.toLowerCase()) ||
                                           request.destinationNeighborhood.toLowerCase().contains(campus.toLowerCase());
              }
            }

            // 🎯 Filtro por Horario
            try {
              final requestTime = TimeOfDay.fromDateTime(
                DateFormat('yyyy-MM-ddTHH:mm:ss').parse(request.departureTime),
              );
              final startMinutes = startTime.hour * 60 + startTime.minute;
              final endMinutes = endTime.hour * 60 + endTime.minute;
              final requestMinutes = requestTime.hour * 60 + requestTime.minute;

              matchesTime = requestMinutes >= startMinutes && requestMinutes <= endMinutes;
            } catch (e) {
              print('Error al parsear la hora del viaje: ${request.departureTime}');
              matchesTime = false; // No incluir si la hora no es válida
            }

            return matchesOriginDestination && matchesTime;
          }).toList();
        });
      });
  }

  void _showAdvancedOptionsModal(BuildContext context, List<TripDetail> requests) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return AdvancedFiltersModal(
          onFilter: (originDestination, campus, startTime, endTime) {
            _applyFilters(originDestination, campus, startTime, endTime, requests);
          },
        );
      },
    );
  }

  void _setFirstLoad(bool value) {
    setState(() {
      _isFirstLoad = value;
    });
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

            // Inicializamos los viajes disponibles
            if (_isFirstLoad) {
              _isFirstLoad = false;
              filteredRequests = availableTrips;
            }

            return TripsAvailableContent(
              state,
              onFirstLoadChanged: _setFirstLoad,
              filteredRequests: filteredRequests,
              searchController: searchController,
              onSearch: (query) => _filterTrips(query, availableTrips),
              onShowAdvancedOptions: () => _showAdvancedOptionsModal(context, availableTrips),
            );
          }

          else if (response is ErrorData) {
            // Muestra un mensaje y redirige al Home
            Future.microtask(() {
              showOverlayMessage(
                context, 
                response.message,
                customTitle: 'Error al obtener los viajes disponibles',
                type: AlertType.error
              );
              context.pop(); // Redirige al Home
            });

            return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
          }

          else {
            return const Center(
              child: Text('Error interno en TripsAvailable')
            );
          }
        },
      ),
    );
  }
}