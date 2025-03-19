
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_state.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_button.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_time_picker.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:carpool_21_app/src/screens/widgets/google_places_auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

// PANTALLA 1 - DONDE EL CONDUCTOR VA A DEFINIR LA UBICACION PARA REALIZAR SU VIAJE
class DriverMapFinder extends StatefulWidget {
  const DriverMapFinder({super.key});

  @override
  State<DriverMapFinder> createState() => _DriverMapFinderState();
}

class _DriverMapFinderState extends State<DriverMapFinder> with WidgetsBindingObserver {

  TextEditingController pickUpController = TextEditingController(); // Lugar origen
  TextEditingController destinationController = TextEditingController(); // Lugar destino

  @override
  void initState() {
    super.initState();

    // Inicializo la hora de partida al momento actual
    context.read<DriverMapFinderBloc>().add(UpdateDepartureTime(time: getCurrentIso8601Time()));

    // Añadir listeners a los TextEditingControllers - Escuchamos los cambios
    pickUpController.addListener(_onPickUpChanged);
    destinationController.addListener(_onDestinationChanged);

    // Añadir observer para detectar cuando la aplicación cambia de estado
    WidgetsBinding.instance.addObserver(this);

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Ejecuta el Init Event cada vez que entro a la pantalla - Esto reinicia el controllador
      context.read<DriverMapFinderBloc>().add(DriverMapFinderInitEvent());
      context.read<DriverMapFinderBloc>().add(FindPosition());

      context.read<DriverMapFinderBloc>().add(ListenDriversPositionSocketIO());
      context.read<DriverMapFinderBloc>().add(ListenDriversDisconnectedSocketIO());
    });
  }

  // Remover listeners y observer cuando el widget se elimine (El evento se dispara cuando pasamos a otra pantalla)
  @override
  void dispose() {
    pickUpController.removeListener(_onPickUpChanged);
    destinationController.removeListener(_onDestinationChanged);
    pickUpController.dispose();
    destinationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Resetea el estado del input de origen
  void _onPickUpChanged() {
    if (pickUpController.text.isEmpty) {
      context.read<DriverMapFinderBloc>().add(ClearPickUpLocation());
    }
  }

  // Resetea el estado del input de destino
  void _onDestinationChanged() {
    if (destinationController.text.isEmpty) {
      context.read<DriverMapFinderBloc>().add(ClearDestinationLocation());
    }
  }

  String getCurrentIso8601Time() {
    DateTime now = DateTime.now();
    DateTime utcNow = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      0, // segundos
      0, // milisegundos
    );
    return utcNow.toIso8601String();
  }

  // Validamos si los campos estan completados para que el boton funcione
  bool _isButtonEnabled(DriverMapFinderState state) {
    return state.pickUpText.isNotEmpty &&
           state.pickUpLatLng != null &&
           state.destinationText.isNotEmpty &&
           state.destinationLatLng != null &&
           state.departureTime != null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Resetea el estado del mapa cuando el usuario sale de la pantalla
      onPopInvoked: (popDisposition) async {
        context.read<DriverMapFinderBloc>().add(DriverMapFinderResetEvent());
        return;
      },
      child: Scaffold(
      body: BlocBuilder<DriverMapFinderBloc, DriverMapFinderState>(
        builder: (context, state) {
          // Verifica si el Controller del Map se inicializo completamente antes de entrar
          if (state.controller == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: state.cameraPosition, // Posicion inicial del mapa
                markers: Set<Marker>.of(state.markers.values), // Marcadores
                polylines: Set<Polyline>.of(state.polylines.values), // Ruta en el mapa
                myLocationEnabled: false, // Icono de ubicacion predeterminado
                myLocationButtonEnabled: false, // Boton de accion para ir a la posicion del usuario
                onMapCreated: (GoogleMapController controller) {
                  if (state.controller != null) {
                    if (!state.controller!.isCompleted) {
                      state.controller?.complete(controller);
                    }
                  }
                },
              ),

              CustomIconBack(
                color: Colors.black,
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 180, left: 30),
                onPressed: () {
                  context.read<DriverMapFinderBloc>().add(DriverMapFinderResetEvent());
                  context.pop();
                }, 
              ),

              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: _googlePlacesAutocomplete()
                ),
              ),

              // Boton de ubicacion del usuario en el mapa
              Positioned(
                right: 20,
                bottom: 120,
                child: FloatingActionButton(
                  onPressed: () {
                    context.read<DriverMapFinderBloc>().add(FindPosition());
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location),
                ),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                  right: 80,
                  left: 80,
                  bottom: MediaQuery.of(context).padding.bottom
                ),
                child: CustomButton(
                  text: 'Continuar',
                  isEnabled: _isButtonEnabled(state),
                  onPressed: () {
                    // Convertir departureTime a DateTime
                    DateTime departureDateTime = DateTime.parse(state.departureTime!);
                    DateTime now = DateTime.now();

                    if (departureDateTime.isBefore(now)) {
                      showOverlayMessage(
                        context, 
                        'Por favor, selecciona un horario de partida que sea posterior al actual.',
                        customTitle: 'Horario invalido',
                        type: AlertType.warning
                      );
                    }
                    else if (_isButtonEnabled(state)) {
                      // Si la fecha elegida es del día siguiente, mostrar advertencia
                      DateTime tomorrow = now.add(const Duration(days: 1));
                      bool isNextDay = departureDateTime.year == tomorrow.year &&
                                      departureDateTime.month == tomorrow.month &&
                                      departureDateTime.day == tomorrow.day;

                      if (isNextDay) {
                        showOverlayMessage(
                          context, 
                          'Estás eligiendo un horario para el día de mañana.',
                          customTitle: 'Horario del viaje',
                          type: AlertType.warning
                        );
                      }

                      // TODO: ELIMINAR - Forma anterior de realizar la navegacion pasando argumentos
                      // Navigator.pushNamed(context, '/driver/map/booking', arguments: {
                      //   'pickUpNeighborhood': state.pickUpNeighborhood,
                      //   'pickUpText': state.pickUpText,
                      //   'pickUpLatLng': state.pickUpLatLng,
                      //   'destinationNeighborhood': state.destinationNeighborhood,
                      //   'destinationText': state.destinationText,
                      //   'destinationLatLng': state.destinationLatLng,
                      //   'departureTime': state.departureTime,
                      // });

                      // Redireccionando al paso siguiente
                      context.push('/driver/0/map/booking', extra: {
                        'pickUpNeighborhood': state.pickUpNeighborhood,
                        'pickUpText': state.pickUpText,
                        'pickUpLatLng': state.pickUpLatLng,
                        'destinationNeighborhood': state.destinationNeighborhood,
                        'destinationText': state.destinationText,
                        'destinationLatLng': state.destinationLatLng,
                        'departureTime': state.departureTime,
                      });
                    }
                  }
                ),
              )
            ],
          );
        },
      ),
    )
    );
  }

  // Seccion de inputs para definir Origen y Destino
  Widget _googlePlacesAutocomplete() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 18, left: 18),
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          BlocBuilder<DriverMapFinderBloc, DriverMapFinderState>(
            builder: (context, state) {
              return GooglePlacesAutoComplete(
                pickUpController,
                state.pickUpText.isNotEmpty ? state.pickUpText : 'Luagar de origen',
                (Prediction prediction) {
                  print('PickUp Controller >>>>>>>>>>: ${state.pickUpLatLng}');
                  print('Lugar de Origen Lat: ${prediction.lat}');
                  print('Lugar de Origen Lat: ${prediction.lng}');

                  // Moviendo la camara a la posicion que ingreso el usuario en el input y agregando el marker a esa posicion
                  context.read<DriverMapFinderBloc>().add(
                    ChangeMapCameraPosition(
                      lat: double.parse(prediction.lat!),
                      lng: double.parse(prediction.lng!)
                    )
                  );

                  // Seteando valores para enviar la informacion del Origen a otra pantalla
                  context.read<DriverMapFinderBloc>().add(
                    OnAutoCompletedPickUpSelected(
                      lat: double.parse(prediction.lat!),
                      lng: double.parse(prediction.lng!),
                      pickUpText: prediction.description ?? '',
                    )
                  );
                },
                enabled: state.pickUpLatLng != null && state.isLocationSelected
              );
            },
          ),
          Container(
            height: 15,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Divider()
          ),
          BlocBuilder<DriverMapFinderBloc, DriverMapFinderState>(
            builder: (context, state) {
              return GooglePlacesAutoComplete(
                destinationController,
                state.destinationText.isNotEmpty ? state.destinationText : 'Luagar destino',
                (Prediction prediction) {
                  print('Destination Controller >>>>>>>>>>: ${state.destinationLatLng}');
                  print('Lugar de Destino Lat: ${prediction.lat}');
                  print('Lugar de Destino Lat: ${prediction.lng}');

                  // Seteando valores para enviar la informacion del Destino a otra pantalla
                  context.read<DriverMapFinderBloc>().add(
                    OnAutoCompletedDestinationSelected(
                      lat: double.parse(prediction.lat!),
                      lng: double.parse(prediction.lng!),
                      destinationText: prediction.description ?? '',
                    )
                  );
                },
                enabled: state.destinationLatLng != null && state.isLocationSelected,
              );
            },
          ),

          const SizedBox(height: 15),

          CustomTimePicker(
            labelText: 'Hora de partida',
            onTimeChanged: (value) {
              context.read<DriverMapFinderBloc>().add(UpdateDepartureTime(time: value));
            },
          ),
        ],
      ),
    );
  }
}
