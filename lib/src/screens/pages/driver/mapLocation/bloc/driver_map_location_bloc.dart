// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/auth_response.dart';
import 'package:carpool_21_app/src/domain/models/driver_position.dart';
import 'package:carpool_21_app/src/domain/useCases/auth/auth_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/drivers_position_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapLocation/bloc/driver_map_location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationBloc extends Bloc<DriverMapLocationEvent, DriverMapLocationState> {

  AuthUseCases authUseCases;
  GeolocationUseCases geolocationUseCases;
  StreamSubscription? positionSubscription;
  DriversPositionUseCases driversPositionUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc socketIOBloc;
  
  DriverMapLocationBloc(
    this.authUseCases, 
    this.geolocationUseCases, 
    this.driversPositionUseCases, 
    this.socketUseCases, 
    this.socketIOBloc
  ): super(DriverMapLocationState()) {
    
    on<DriverMapLocationInitEvent>((event, emit) async {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();
      AuthResponse? authResponse = await authUseCases.getUserSession.run();
      
      emit(
        state.copyWith(
          controller: controller,
          idDriver: authResponse?.user!.idUser ?? 1
        )
      );
    });

    on<FindPosition>((event, emit) async {
      print('Aqui Find Position');
      
      // User Position
      Position position = await geolocationUseCases.findPosition.run();
      print('Position Lat: ${position.latitude}');
      print('Position Lng: ${position.longitude}');
      print(state.idDriver);

      // Seteando la posicion en el Mapa
      emit(
        state.copyWith(
          position: position,
        )
      );

      // Modificando la posicion de la camara en el mapa
      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));
      // Agrego el marker al mapa
      add(AddMyPositionMarker(lat: position.latitude, lng: position.longitude));
      // ------------------------------------------------
      
      // Ejecuto la funcion para obtener la posicion del usuario en todo momento
      Stream<Position> positionStream = geolocationUseCases.getPositionStream.run();

      // Position - Escucha la posicion en tiempo real
      // listen - Nos devuelve la posicion del usuario en tiempo real segun donde estemos ubicados
      positionSubscription = positionStream.listen((Position position) {
        add(UpdateLocation(position: position));
        add(SaveLocationData(
          driverPosition: DriverPosition(
            idDriver: state.idDriver!, 
            lat: position.latitude, 
            lng: position.longitude
          )
        ));

      });
    });

    on<AddMyPositionMarker>((event, emit) async {
      // Trayendo la imagen del marker
      BitmapDescriptor imageMarker = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-current-location.png');

      // Actualizando estado de los marcadores
      Marker marker = geolocationUseCases.getMarker.run(
        'MyLocation',
        event.lat,
        event.lng,
        'Mi Posición',
        '',
        imageMarker
      );

      // Agregando el marcador al mapa
      emit(
        state.copyWith(
          markers: {
            marker.markerId: marker // Adding Marker
          },
        )
      );
    });

    // Ajustando la posicion de la camara (y el marker) en el mapa segun la posicion que el usuario elijio
    // El usuario puede elegir la posicion desde el input o moviendo el marker con la camara
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition');
      print(event.lat);
      print(event.lng);
      print(state.controller!.future);

      try {
        GoogleMapController googleMapController = await state.controller!.future;

        await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.lat, event.lng),
            zoom: 13,
            bearing: 0
          )
        ));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    }); 

    // Emitimos la nueva ubicación del Driver
    on<EmitDriverPositionSocketIO>((event, emit) async {
      print('Emitiendo Posicion del Driver');
      if(socketIOBloc.state.socket != null) {
        socketIOBloc.state.socket?.emit('change_driver_position', {
          'id': state.idDriver,
          'lat': state.position!.latitude,
          'lng': state.position!.longitude
        });
      }
    });

    // Actualizando la posicion del usuario
    on<UpdateLocation>((event, emit) async {
      print('ACTUALIZACIÓN DE UBICACIÓN');
      print('LAT: ${event.position.latitude}');
      print('LNG: ${event.position.longitude}');

      // Modifico la posicion del marker en el mapa
      add(AddMyPositionMarker(lat: event.position.latitude, lng: event.position.longitude));
      
      // Actualizando la posicion de la camara en el mapa segun la ubicacion del usuario
      add(ChangeMapCameraPosition(lat: event.position.latitude, lng: event.position.longitude));
      
      emit(
        state.copyWith(
          position: event.position
        )
      );

      // Emitimos el cambio de posicion del Driver
      add(EmitDriverPositionSocketIO());
    });

    // Detenemos el seguimiento de nuestra posicion
    on<StopLocation>((event, emit) {
      positionSubscription?.cancel();
      add(DeleteLocationData(idDriver: state.idDriver!));
    });

    // Guardando la informacion de la posicion del Driver
    on<SaveLocationData>((event, emit) async {
      await driversPositionUseCases.createDriverPosition.run(event.driverPosition);
    }); 
    
    // Eliminando la informacion de la posicion del Driver
    on<DeleteLocationData>((event, emit) async {
      await driversPositionUseCases.deleteDriverPosition.run(event.idDriver);
    });

  }
}