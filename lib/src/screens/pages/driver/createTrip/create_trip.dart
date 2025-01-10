// ignore_for_file: avoid_print
import 'dart:ui';

import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/create_trip_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/create_trip_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/create_trip_state.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/create_trip_content.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_dialog.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTripPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const CreateTripPage({
    super.key,
    required this.arguments
  });

  @override
  State<CreateTripPage> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTripPage> {
  late String pickUpNeighborhood;
  late String pickUpText;
  late LatLng pickUpLatLng;
  late String destinationNeighborhood;
  late String destinationText;
  late LatLng destinationLatLng;
  late String departureTime;
  late TimeAndDistanceValues timeAndDistanceValues;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los datos de Origen y Destino desde DriverMapBooking
      final args = widget.arguments;

      // final args = ModalRoute.of(context)!.settings.arguments as Map;
      pickUpNeighborhood = args['pickUpNeighborhood'];
      pickUpText = args['pickUpText'];
      pickUpLatLng = args['pickUpLatLng'];
      destinationNeighborhood = args['destinationNeighborhood'];
      destinationText = args['destinationText'];
      destinationLatLng = args['destinationLatLng'];
      departureTime = args['departureTime'];
      timeAndDistanceValues = args['timeAndDistanceValues'];
      
      print(pickUpNeighborhood);
      print(destinationNeighborhood);
      
      context.read<CreateTripBloc>().add(InitializeTrip(
        pickUpNeighborhood: pickUpNeighborhood,
        pickUpText: pickUpText,
        pickUpLatLng: pickUpLatLng,
        destinationNeighborhood: destinationNeighborhood,
        destinationText: destinationText,
        destinationLatLng: destinationLatLng,
        departureTime: departureTime,
        timeAndDistanceValues: timeAndDistanceValues,
      ));
    });
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CreateTripBloc, CreateTripState>(
        listener: (context, state) {
          final responseDriverTripRequest = state.responseDriverTripRequest;
          
          // Esperando la respuesta
          if (responseDriverTripRequest is Loading) {
            _setLoading(true);
          } else {
            _setLoading(false);
          }

          // Success Status
          if (responseDriverTripRequest is Success) {
            print('Viaje Creado Exitosamente >>>>>>>>>>>>>>>>>>>>>>>>>>>');
            print(responseDriverTripRequest.data);

            TripDetail driverTripRequest = responseDriverTripRequest.data; 
            int? idDriverRequest = driverTripRequest.idTrip;
            
            // Emitimos la nueva oferta de viaje
            context.read<CreateTripBloc>().add(EmitNewTripRequestSocketIO());
           
            // Reseteamos los valores del State
            context.read<CreateTripBloc>().add(ResetState());

            // Redireccionamiento a la pantalla de Detalle de Viaje
            context.push('/driver/0/trip/detail', extra: {
              'idDriverRequest':  idDriverRequest,
            });

            Fluttertoast.showToast(msg: 'Solicitud enviada', toastLength: Toast.LENGTH_LONG);
          }
          
          // Error Status
          else if (responseDriverTripRequest is ErrorData) {
            Fluttertoast.showToast(
              msg: 'Error al realizar la reserva: ${responseDriverTripRequest.message}',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: Stack(
          children: [
            _headerProfile(context),
            CustomIconBack(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
              onPressed: () {
                context.pop();
              },
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CreateTripBloc, CreateTripState>(
                builder: (context, state) {
                  final resVehicleList = state.responseVehicleList; 

                  // Loading Status
                  if (resVehicleList is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Success Status
                  else if (resVehicleList is Success) {
                    List<CarInfo> vehicleList = resVehicleList.data as List<CarInfo>;

                    return CreateTripContent(
                      neighborhoodPreSelected: state.neighborhoodPreSelected!,
                      pickUpText: state.pickUpText,
                      destinationNeighborhood: state.destinationNeighborhood,
                      destinationText: state.destinationText,
                      timeAndDistanceValues: state.timeAndDistanceValues,
                      vehicleList: vehicleList,
                      onNeighborhoodChanged: (value) {
                        context
                          .read<CreateTripBloc>()
                          .add(UpdateNeighborhood(neighborhood: value!));
                      },
                      onVehicleChanged: (value) {
                        context
                          .read<CreateTripBloc>()
                          .add(UpdateVehicle(vehicle: value!));
                      },
                      onAvailableSeatsChanged: (value) {
                        context
                          .read<CreateTripBloc>()
                          .add(UpdateAvailableSeats(seats: int.parse(value!)));
                      },
                      onTripDescriptionChanged: (value) {
                        context
                          .read<CreateTripBloc>()
                          .add(UpdateTripObservations(tripObservationsInput: value!));
                      },
                      onConfirm: () {
                        CustomDialog(
                          context: context,
                          title: 'Estás por crear un nuevo Viaje. ¿Querés confirmarlo?',
                          content: 'Podés cancelar o editar el detalle de tu viaje hasta 30 minutos antes de su comienzo.',
                          icon: Icons.check_circle_rounded,
                          onPressedSend: () {
                            context.read<CreateTripBloc>().add(CreateTripRequest());
                          },
                          textSendBtn: 'Crear',
                          textCancelBtn: 'Cancelar',
                        );
                      },
                    );
                  }

                  // Error Status
                  else if (resVehicleList is ErrorData) {
                    Future.microtask(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(resVehicleList.message)),
                      );
                      Navigator.of(context).pop(); // Redirige al Home
                    });

                    return const SizedBox.shrink(); // Devuelve un widget vacío mientras se redirige
                  }  
                  
                  else {
                    return Container(
                      child: const Text('Error interno en ReserveDetail')
                    );
                  }
                },
              ),
            ),

            // CircularProgressIndicator visible cuando _isLoading sea true esperando la creación del viaje
            if (_isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0), // Desenfoque
                child: Container(
                  color: Colors.black.withOpacity(0.3), // Fondo semi-transparente
                ),
              ),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _headerProfile(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.33),
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
        height: MediaQuery.of(context).size.height * 0.33,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 64, 52), // Top color
              Color(0xFF00A48B), // Bottom color
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: const Text(
          'REGISTRAR VIAJE',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
    );
  }
}
