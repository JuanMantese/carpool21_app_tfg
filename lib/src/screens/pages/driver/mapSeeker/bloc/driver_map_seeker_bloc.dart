// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/placemark_data.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/socket/socket_use_cases.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapSeeker/bloc/driver_map_seeker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapFinderBloc extends Bloc<DriverMapFinderEvent, DriverMapFinderState> {

  GeolocationUseCases geolocationUseCases;
  SocketUseCases socketUseCases;
  SocketIOBloc blocSocketIO;

  DriverMapFinderBloc(
    this.geolocationUseCases, 
    this.socketUseCases, 
    this.blocSocketIO
  ): super(const DriverMapFinderState()) {
    
    on<DriverMapFinderInitEvent>((event, emit) {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();
      emit(
        state.copyWith(
          controller: controller
        )
      );
    });

    on<UpdateDepartureTime>((event, emit) {
      print('Departure Time: ${event.time}');
      emit(
        state.copyWith(
          departureTime: event.time
        )
      );
    });

    on<FindPosition>((event, emit) async {
      // User Position
      Position position = await geolocationUseCases.findPosition.run();
      print('Entrando en Find Position ---------------------------------');
      print('Lat: ${position.latitude}');
      print('Lng: ${position.longitude}');

      // Trayendo la imagen del marker
      BitmapDescriptor imageMarker = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-current-location.png');

      // Actualizando estado de los marcadores
      Marker userMarker = geolocationUseCases.getMarker.run(
        'IdMyLocation',
        position.latitude,
        position.longitude,
        'Mi Posición',
        '',
        imageMarker
      );

      // Add marker to existing markers and update state
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers)
        ..[userMarker.markerId] = userMarker;

      // Agregando el marcador al mapa
      emit(
        state.copyWith(
          position: position, // Change Position State
          markers: updatedMarkers, // Adding Marker keeping existing ones
        )
      );

      // Modificando la posicion de la camara en el mapa
      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));

      print('Position Lat: ${position.latitude}');
      print('Position Lng: ${position.longitude}');
    });

    // Ajustando la posicion de la camara (y el marker) en el mapa segun la posicion que el usuario elijio
    // El usuario puede elegir la posicion desde el input o moviendo el marker con la camara
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition ---------------------------------');
      print('Lat: ${event.lat}');
      print('Lng: ${event.lng}');

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

    // Obteniendo ubicacion del marker en el mapa al mover la camara
    // on<OnCameraMove>((event, emit) {
    //   emit(
    //     state.copyWith(
    //       cameraPosition: event.cameraPosition
    //     )
    //   );
    // });

    // Al terminar de mover la camara, fijo el marcador en la posicion donde esta se encuentra
    // Estableciendo la direccion la que el marker esta ubicado
    // on<OnCameraIdle>((event, emit) async {
    //   try {
    //     PlacemarkData placemarkData = await geolocationUseCases.getPlacemarkData.run(state.cameraPosition);
    //     emit(
    //       state.copyWith(
    //         placemarkData: placemarkData
    //       )
    //     );  
    //   } catch (e) {
    //     print('OnCameraIdle Error: $e');
    //   }
    // });

    on<SelectPredefinedLocation>((event, emit) async {
      print('SelectPredefinedLocation ---------------------------------');
      print('Lat: ${event.location.latitude}');
      print('Lng: ${event.location.longitude}');

      BitmapDescriptor markerIcon = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-small.png');

      // Obteniendo la dirección del lugar
      PlacemarkData placemarkData  = await geolocationUseCases.getLocationData.run(event.location);
      print('PlacemarkData: ${placemarkData.address}');

      Marker destinationMarker = Marker(
        markerId: MarkerId(event.locationType == 'pickUp' ? 'PickUpLocation' : 'DestinationLocation'),
        position: event.location,
        infoWindow: InfoWindow(title: event.locationType == 'pickUp' ? 'Lugar de Origen' : 'Lugar de Destino'),
        icon: markerIcon,
      );

      // Add marker to existing markers and update state
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers)
        ..[destinationMarker.markerId] = destinationMarker;

      if (event.locationType == 'pickUp') {
        print('pickUp entramos');
        emit(state.copyWith(
          pickUpNeighborhood: event.neighborhood,
          pickUpText: event.address,
          pickUpLatLng: event.location,
          markers: updatedMarkers,
          isLocationSelected: true
        ));
      } else {
        print('destination entramos');
        emit(state.copyWith(
          destinationNeighborhood: event.neighborhood,
          destinationText: event.address,
          destinationLatLng: event.location,
          markers: updatedMarkers,
          isLocationSelected: true
        ));
      }
      print('--------------------------------');

      add(ChangeMapCameraPosition(lat: event.location.latitude, lng: event.location.longitude));
    });

    // Enviando los datos de Origen a otra pantalla
    on<OnAutoCompletedPickUpSelected>((event, emit) async {
      // Create marker for pick-up location
      BitmapDescriptor pickUpMarkerIcon = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-green-small.png');
      Marker pickUpMarker = Marker(
        markerId: const MarkerId('PickUpLocation'),
        position: LatLng(event.lat, event.lng),
        infoWindow: InfoWindow(title: 'Lugar de Origen', snippet: event.pickUpText),
        icon: pickUpMarkerIcon,
      );

      // Add marker to existing markers and update state
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers)
        ..[pickUpMarker.markerId] = pickUpMarker;

      emit(
        state.copyWith(
          pickUpLatLng: LatLng(event.lat, event.lng),
          pickUpText: event.pickUpText,
          markers: updatedMarkers,
          isLocationSelected: false
        )
      );

      // Move camera to the new marker position
      add(ChangeMapCameraPosition(lat: event.lat, lng: event.lng));

      if (state.destinationLatLng != null) {
        add(DrawPolyline());
      }
    });

    // Enviando los datos de Destino a otra pantalla
    on<OnAutoCompletedDestinationSelected>((event, emit) async {
      // Create marker for destination location
      BitmapDescriptor destinationMarkerIcon = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-small.png');
      Marker destinationMarker = Marker(
        markerId: const MarkerId('DestinationLocation'),
        position: LatLng(event.lat, event.lng),
        infoWindow: InfoWindow(title: 'Lugar de Destino', snippet: event.destinationText),
        icon: destinationMarkerIcon,
      );

      // Add marker to existing markers and update state
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers)
        ..[destinationMarker.markerId] = destinationMarker;

      emit(
        state.copyWith(
          destinationLatLng: LatLng(event.lat, event.lng),
          destinationText: event.destinationText,
          markers: updatedMarkers,
          isLocationSelected: false
        )
      );

      if (state.pickUpLatLng != null) {
        add(DrawPolyline());
      }
    });

    // Agregando Polyline - Ruta del lugar de origen al lugar de destino
    on<DrawPolyline>((event, emit) async {
      print('DrawPolyline Enter ---------------------------------------');
      print('Lat: ${state.pickUpLatLng}');
      print('Lng: ${state.destinationLatLng}');
      print('---------------------------------------');

      // Obteniendo las coordenadas/direcciones del origen y destino para trazar la ruta
      List<LatLng> polylineCoordinates = await geolocationUseCases.getPolyline.run(state.pickUpLatLng!, state.destinationLatLng!);

      if (state.pickUpLatLng != null && state.destinationLatLng != null) {
        const PolylineId polylineId = PolylineId('route');
        
        final Polyline polyline = Polyline(
          polylineId: polylineId,
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        );

        final updatedPolylines = Map<PolylineId, Polyline>.from(state.polylines)
          ..[polylineId] = polyline;

        emit(
          state.copyWith(
            polylines: updatedPolylines
          )
        );
      }
    });

    on<ClearPickUpLocation>((event, emit) {
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers);
      updatedMarkers.remove(const MarkerId('PickUpLocation'));
      
      emit(state.copyWith(
        pickUpLatLng: null,
        pickUpText: '',
        markers: updatedMarkers,
        polylines: const <PolylineId, Polyline>{},
      ));
    });

    on<ClearDestinationLocation>((event, emit) {
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers);
      updatedMarkers.remove(const MarkerId('DestinationLocation'));

      emit(state.copyWith(
        destinationLatLng: null,
        destinationText: '',
        markers: updatedMarkers,
        polylines: const <PolylineId, Polyline>{},
      ));
    });

    on<DriverMapFinderResetEvent>((event, emit) {
      print('Reseteando los valores >>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      emit(const DriverMapFinderState(
        pickUpLatLng: null,
        pickUpText: '',
        destinationLatLng: null,
        destinationText: '',
        polylines: <PolylineId, Polyline>{},
        isLocationSelected: false
      ));
    });


  /** Debo crear un mapa para el Passajero, para que pueda entrar a ver los conductores cercanos, y ver los viajes disponibles de esos conductores
      * Esta funcionalidad debe estar del lado del Pasajero, pero la agregue aca para probarla 
  */

    // Buscando los conductores activos segun su posicion
    on<ListenDriversPositionSocketIO>((event, emit) async {
      if (blocSocketIO.state.socket != null ) {
        blocSocketIO.state.socket?.on('new_driver_position', (data) {
          print('Escuchando cambios en la posicion del Driver');
          print('Id_Socket: ${data['id_socket']}');
          print('Id: ${data['id']}');
          print('Lat: ${data['lat']}');
          print('Lng: ${data['lng']}');

          // Vamos a mostrar un Marker cada vez que el usuario Driver cambia de posicion
          add(
            AddDriverPositionMarker(
              idSocket: data['id_socket'] as String, 
              id: data['id'] as int, 
              lat: data['lat'] as double, 
              lng: data['lng'] as double
            )
          );
        });
      }
    });

    on<ListenDriversDisconnectedSocketIO>((event, emit) {
      if (blocSocketIO.state.socket != null ) {
        blocSocketIO.state.socket?.on('driver_disconnected', (data) {
          print('Id: ${data['id_socket']}');
          add(RemoveDriverPositionMarker(idSocket: data['id_socket'] as String));
        });
      }
    });

    // on<RemoveDriverPositionMarker>((event, emit) {
    //   emit(
    //       state.copyWith(
    //         markers: Map.of(state.markers)..remove(MarkerId(event.idSocket))
    //       )
    //     );
    // });

    on<AddDriverPositionMarker>((event, emit) async {
      // Cambiar imagen por - car pin o car_pin 
      BitmapDescriptor descriptor = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-small.png');
      Marker marker = geolocationUseCases.getMarker.run(
        event.idSocket,
        event.lat,
        event.lng,
        'Conductor disponible',
        '',
        descriptor
      );
      emit(
        state.copyWith(
          markers: Map.of(state.markers)..[marker.markerId] = marker
        )
      );
    });

    // Hasta aqui debo pasar las funcionalidades -----------------------------------------------

  }

}