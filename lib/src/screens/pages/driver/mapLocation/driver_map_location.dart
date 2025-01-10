import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/blocSocketIO/socket_io_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_state.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// PANTALLA DONDE EL CONDUCTOR VA A BUSCAR LA UBICACION PARA REALIZAR SU VIAJE
class DriverMapLocation extends StatefulWidget {
  const DriverMapLocation({super.key});

  @override
  State<DriverMapLocation> createState() => _DriverMapLocationState();
}

class _DriverMapLocationState extends State<DriverMapLocation> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    // Añadir observer para detectar cuando la aplicación cambia de estado
    WidgetsBinding.instance.addObserver(this);

    // Espera que todos los elementos del build sean construidos antes de ejecutarse
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Ejecuta el Init Event cada vez que entro a la pantalla - Esto reinicia el controllador
      context.read<DriverMapLocationBloc>().add(DriverMapLocationInitEvent());
      context.read<DriverMapLocationBloc>().add(FindPosition());

      // context.read<ClientMapSeekerBloc>().add(ListenDriversPositionSocketIO());
      // context.read<ClientMapSeekerBloc>().add(ListenDriversDisconnectedSocketIO());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriverMapLocationBloc, DriverMapLocationState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                // Mapa de Google
                mapType: MapType.normal,
                initialCameraPosition: state.cameraPosition, // Posicion inicial del mapa
                markers: Set<Marker>.of(state.markers.values), // Marcadores
                onMapCreated: (GoogleMapController controller) {
                  // controller.setMapStyle('JSON');
                  if (state.controller != null) {
                    if (!state.controller!.isCompleted) {
                      state.controller?.complete(controller);
                    }
                  }
                },
              ),
              Container(
                height: 120,
                margin: const EdgeInsets.only(top: 80),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                  right: 60,
                  left: 60,
                  bottom: MediaQuery.of(context).padding.bottom
                ),
                child: CustomButton(
                  text: 'Detener Localizacion',
                  onPressed: () {
                    // Desconectamos Socket IO
                    context.read<SocketIOBloc>().add(DisconnectSocketIO());
                    
                    // Detenemos el seguimiento del usuario
                    // context.read<DriverMapLocationBloc>().add(StopLocation());
                  }
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
