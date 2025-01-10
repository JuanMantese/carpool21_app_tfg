// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_event.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/bloc/trip_available_detail_state.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripAvailableDetail/trip_svailable_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripAvailableDetailPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const TripAvailableDetailPage({
    super.key,
    required this.arguments
  });

  @override
  State<TripAvailableDetailPage> createState() => _TripAvailableDetailPageState();
}

class _TripAvailableDetailPageState extends State<TripAvailableDetailPage> {
  // Inicializando variables
  late int idTrip;
  late LatLng pickUpLatLng;
  late String pickUpText;
  late LatLng destinationLatLng;
  late String destinationText;
  late String departureTime;
  late double compensation;
  late Driver driver;

  bool _isLoading = false;
  bool _isMapControllerReady = false;

  @override
  void initState() {
    super.initState();

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Recibiendo los datos de Origen y Destino desde AvailableTrips
      final args = widget.arguments;

      idTrip = args['idTrip'];
      pickUpLatLng = args['pickUpLatLng'];
      pickUpText = args['pickUpText'];
      destinationLatLng = args['destinationLatLng'];
      destinationText = args['destinationText'];
      departureTime = args['departureTime'];
      driver = args['driver'];
      compensation = args['compensation'];
      print('idTrip $idTrip');
      print('pickUpLatLng $pickUpLatLng');
      print('pickUpText $pickUpText');
      print('destinationLatLng $destinationLatLng');
      print('destinationText $destinationText');
      print('departureTime $departureTime');

      context
        .read<TripAvailableDetailBloc>()
        .add(TripAvailableDetailInitEvent(
          pickUpLatLng: pickUpLatLng,
          destinationLatLng: destinationLatLng,
          pickUpText: pickUpText,
          destinationText: destinationText,
          departureTime: departureTime,
          compensation: compensation,
          driver: driver,
        ));
      
      // Aca se ejecuta la funcion para agregar la ruta en el mapa origen/destino
      context.read<TripAvailableDetailBloc>().add(AddPolyline());
 
      // Ubicamos la camara sobre la ruta marcada
      // context.read<TripAvailableDetailBloc>().add(ChangeMapCameraPosition(
      //   pickUpLatLng: pickUpLatLng,
      //   destinationLatLng: destinationLatLng
      // ));

      // Trayendo los datos: Tiempo estimado del trayecto y Distancia del punto de origen al punto de destino
      // context.read<TripAvailableDetailBloc>().add(GetTimeAndDistanceValues());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _onMapControllerInitialized() {
    print("Mapa inicializado");

    setState(() {
      _isMapControllerReady = true;
    });

    if (_isMapControllerReady) {
      print('Entramos primero aqui');
      context.read<TripAvailableDetailBloc>().add(ChangeMapCameraPosition(
        pickUpLatLng: pickUpLatLng,
        destinationLatLng: destinationLatLng
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TripAvailableDetailBloc, TripAvailableDetailState>(
        listener: (context, state) {
          final responseReserveRes = state.responseReserve;
          print(state.responseReserve);
          print('TripAvailableDetail');
          print(responseReserveRes);
          
          // Esperando la respuesta
          if (responseReserveRes is Loading) {
            _setLoading(true);
          } else {
            _setLoading(false);
          }

          if (responseReserveRes is Success) { 
            print('Entro en responseReserveRes');

            ReserveDetail responseReserve = responseReserveRes.data; 
            print(responseReserve.toJson());
            int? idReserve = responseReserve.idReservation;
            print(idReserve);

            // Emitimos la nueva oferta de viaje
            context.read<TripAvailableDetailBloc>().add(EmitNewReserveRequestSocketIO());

            // Reseteamos los valores del State
            context.read<TripAvailableDetailBloc>().add(ResetState());

            context.push('/passenger/0/reserve/detail', extra: {
              'idReserve': idReserve
            });

            Fluttertoast.showToast(msg: 'Reserva realizada', toastLength: Toast.LENGTH_LONG);

          } else if (responseReserveRes is ErrorData) {
            Fluttertoast.showToast(
              msg: 'Error al realizar la reserva: ${responseReserveRes.message}',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<TripAvailableDetailBloc, TripAvailableDetailState>(
          builder: (context, state) {
            return Stack(
              children: [
                if (_isMapControllerReady || !_isLoading)
                  TripAvailableDetailContent(
                    state, 
                    onReserve: () {
                      context.read<TripAvailableDetailBloc>().add(CreateReserve(tripRequestId: idTrip));
                    },
                    onMapInitialized: _onMapControllerInitialized,
                  ),
                
                if (!_isMapControllerReady || _isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ]
            );
          })  
        ,
      ),
    );
  }
}