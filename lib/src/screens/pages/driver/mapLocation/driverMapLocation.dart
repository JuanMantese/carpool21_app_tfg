import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driverMapLocationBloc.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driverMapLocationEvent.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driverMapLocationState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      context.read<DriverMapLocationBloc>().add(ConnectSocketIO());
      context.read<DriverMapLocationBloc>().add(FindPosition());

      // context.read<ClientMapSeekerBloc>().add(ListenDriversPositionSocketIO());
      // context.read<ClientMapSeekerBloc>().add(ListenDriversDisconnectedSocketIO());
    });
  }

  // El evento se ejecuta cuando pasamos a otra ventana
  @override
  void dispose() {
    super.dispose();

    // Ejecuto la funcion una vez que todos los elementos en pantalla fueron cargados
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {        
        // Detenemos el seguimiento del usuario
        context.read<DriverMapLocationBloc>().add(StopLocation());
        // Desconectamos Socket IO
        context.read<DriverMapLocationBloc>().add(DisconnectSocketIO());
      }
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
                    // Detenemos el seguimiento del usuario
                    context.read<DriverMapLocationBloc>().add(StopLocation());
                    // Desconectamos Socket IO
                    context.read<DriverMapLocationBloc>().add(DisconnectSocketIO());
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
