
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/createTripBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/createTripEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/bloc/createTripState.dart';
import 'package:carpool_21_app/src/screens/pages/driver/createTrip/createTripContent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomDialog.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

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
  late String destinationNeighborhood;
  late String destinationText;
  late String departureTime;
  late TimeAndDistanceValues timeAndDistanceValues;
  late DriverMapBookingInfoState state;

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
      destinationNeighborhood = args['destinationNeighborhood'];
      destinationText = args['destinationText'];
      departureTime = args['departureTime'];
      timeAndDistanceValues = args['timeAndDistanceValues'];
      state = args['state'];
      
      print(pickUpNeighborhood);
      print(destinationNeighborhood);
      
      context.read<CreateTripBloc>().add(InitializeTrip(
        pickUpNeighborhood: pickUpNeighborhood,
        pickUpText: pickUpText,
        pickUpLatLng: state.pickUpLatLng!,
        destinationNeighborhood: destinationNeighborhood,
        destinationText: destinationText,
        destinationLatLng: state.destinationLatLng!,
        departureTime: state.departureTime!,
        timeAndDistanceValues: timeAndDistanceValues,
        state: state,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CreateTripBloc, CreateTripState>(
        listener: (context, state) {
          final responseDriverTripRequest = state.responseDriverTripRequest;
          
          if (responseDriverTripRequest is Success) {
            print(responseDriverTripRequest.data);
            TripDetail driverTripRequest = responseDriverTripRequest.data; 
            int? idDriverRequest = driverTripRequest.idTrip;
            
            // DESCOMENTAR
            // context.read<CreateTripBloc>().add(EmitNewClientRequestSocketIO(idDriverRequest: idDriverRequest));
           
            // Navigator.pushNamed(context, '/driver/trip/detail', 
            //   arguments:{
            //     'idDriverRequest':  idDriverRequest,
            //   }
            // );

            context.push('/driver/0/trip/detail', extra: {
              'idDriverRequest':  idDriverRequest,
            });

            Fluttertoast.showToast(msg: 'Solicitud enviada', toastLength: Toast.LENGTH_LONG);
          }
        },
        child: Stack(
          children: [
            _headerProfile(context),
            CustomIconBack(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
              onPressed: () {
                // Navigator.pop(context);
                context.pop();
              },
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CreateTripBloc, CreateTripState>(
                builder: (context, state) {
                  if (state.vehicleList == null) {
                    return const Center(child: CircularProgressIndicator());
                  } 
                  return CreateTripContent(
                    neighborhoodPreSelected: state.neighborhoodPreSelected!,
                    pickUpText: state.pickUpText,
                    destinationNeighborhood: state.destinationNeighborhood,
                    destinationText: state.destinationText,
                    timeAndDistanceValues: state.timeAndDistanceValues,
                    vehicleList: state.vehicleList!,
                    state: state.state,
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
  
                          // Navigator.popAndPushNamed(context, '/driver/trip/detail');
                          // Lógica para redirigir a la home cuando se presione el botón de atrás
                        },
                        textSendBtn: 'Crear',
                        textCancelBtn: 'Cancelar',
                      );
                    },
                  );
                },
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
