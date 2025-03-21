// ignore_for_file: avoid_print
import 'dart:async';
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/src/domain/models/time_and_distance_value.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/useCases/driver-trip-request/driver_trip_request_use_cases.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/geolocation_use_cases.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_event.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapTripDriver/bloc/map_trip_driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTripDriverBloc extends Bloc<MapTripDriverEvent, MapTripDriverState> {
  
  StreamSubscription? positionSubscription;

  GeolocationUseCases geolocationUseCases;
  DriverTripRequestsUseCases driverTripRequestsUseCases;
  SocketIOBloc socketIOBloc;

  // Constructor
  MapTripDriverBloc(
    this.geolocationUseCases, 
    this.driverTripRequestsUseCases,
    this.socketIOBloc
  ): super(const MapTripDriverState()) {

    on<GetMapTripDetail>((event, emit) async {
      emit(
        state.copyWith(
          responseGetTripDetail: Loading(),
        )
      );

      // Ejecutamos la consulta y obtenemos el resultado
      Resource<TripDetail> responseTripDetail = await driverTripRequestsUseCases.getTripDetailUseCase.run(event.idTrip);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseGetTripDetail: responseTripDetail,
        ),
      );

      if (responseTripDetail is Success<TripDetail>) {
        final data = responseTripDetail.data;

        emit(
          state.copyWith(
            idTrip: data.idTrip,
            pickUpLatLng: LatLng(data.pickupLat, data.pickupLng),
            destinationLatLng: LatLng(data.destinationLat, data.destinationLng)
          )
        );

        add(FindPosition());
        add(AddMarkerPickup(lat: data.pickupLat, lng: data.pickupLng));
        add(AddMarkerDestination(lat: data.destinationLat, lng: data.destinationLng));
      }
    });

  
    on<MapTripDriverInitMap>((event, emit) async {
      print('InitializeMap -------------------------------------');

      // Inicializo el controlador del mapa cada vez que ingreso a la pantalla con Mapa
      Completer<GoogleMapController> initializeController = Completer<GoogleMapController>();
      
      emit(
        state.copyWith(
          controller: initializeController,
        )
      );
      print('Completed -------------------------------------');
    });

    on<AddMarkerPickup>((event, emit) async {
      print('AddMarkerPickup - LAT: ${event.lat} y LNG: ${event.lng}');

      BitmapDescriptor pickUpMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-small.png');

      Marker markerPickUp = geolocationUseCases.getMarker.run(
        'originLocation',
        event.lat,
        event.lng,
        'Lugar de Origen',
        '',
        pickUpMarkerImg
      );

      emit(
        state.copyWith(
          markers: Map.of(state.markers)..[markerPickUp.markerId] = markerPickUp
        )
      );
    });

    on<AddMarkerDestination>((event, emit) async {
      print('AddMarkerDestination - LAT: ${event.lat} y LNG: ${event.lng}');

      BitmapDescriptor destinationMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-green-small.png');
     
      Marker markerDestination = geolocationUseCases.getMarker.run(
        'destinationLocation',
        event.lat,
        event.lng,
        'Lugar de Destino',
        '',
        destinationMarkerImg
      );

      emit(
        state.copyWith(
          markers: Map.of(state.markers)..[markerDestination.markerId] = markerDestination
        )
      );
    });

    on<AddMarkerPositionDriver>((event, emit) async {
      print('AddMarkerPositionDriver - LAT: ${event.lat} y LNG: ${event.lng}');

      BitmapDescriptor driverMarkerImg = await geolocationUseCases.createMarker.run('lib/assets/img/map-marker-current-location.png');
     
      Marker markerDriver = geolocationUseCases.getMarker.run(
        'driver',
        event.lat,
        event.lng,
        'Mi Posición',
        '',
        driverMarkerImg,
        anchor: const Offset(0.5, 0.5),
      );

      emit(
        state.copyWith(
          markers: Map.of(state.markers)..[markerDriver.markerId] = markerDriver
        )
      );
    });


    // Ajustando la posicion de la camara en el mapa segun la ruta elegida
    on<ChangeMapCameraPosition>((event, emit) async {
      print('Entramos a ChangeMapCameraPosition ------------------------------------');
      print('LAT: ${event.lat} y LNG: ${event.lng}');

      try {
        GoogleMapController googleMapController = await state.controller!.future;

        await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.lat, event.lng),
            zoom: 18,
            bearing: 0
          )
        ));
        print('Posicionamiento completado');
      } catch (e) {
        print('ERROR EN ChangeMapCameraPosition: $e');
      }
    });

    on<FindPosition>((event, emit) async {
      print('Entramos a FindPosition ------------------------------------');

      // User Position
      geolocator.Position position = await geolocationUseCases.findPosition.run();
      print('Position Lat: ${position.latitude}');
      print('Position Lng: ${position.longitude}');

      // Agrego el marker al mapa
      add(AddMarkerPositionDriver(lat: position.latitude, lng: position.longitude));
      // Modificando la posicion de la camara en el mapa
      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));

      
      // Ejecuto la funcion para obtener la posicion del usuario en todo momento
      Stream<geolocator.Position> positionStream = geolocationUseCases.getPositionStream.run();

      // Position - Escucha la posicion en tiempo real
      // listen - Nos devuelve la posicion del usuario en tiempo real segun donde estemos ubicados
      positionSubscription = positionStream.listen((geolocator.Position position) {
        add(UpdatePosition(position: position));
      });

      emit(state.copyWith(
        position: position
      ));

      add(AddPolyline());
    });

    // Actualizando la posicion del usuario
    on<UpdatePosition>((event, emit) async {
      print('Entramos a UpdatePosition ------------------------------------');
      print('LAT: ${event.position.latitude} y LNG: ${event.position.longitude}');

      // Verificar si la posición del conductor es la misma que la del destino usando LatLng
      // if (_isCloseToDestination(event.position.latitude, event.position.longitude)) {
      //   print('El conductor ha llegado al destino');
      //   return; // Detenemos el procesamiento si ya llegamos al destino
      // }

      // Llamamos a la función para verificar si el conductor está a menos de 70 metros del destino
      bool isArrivedToDestination = _isCloseToDestination(event.position, state.destinationLatLng!);

      if (isArrivedToDestination) {
        // Si el conductor está cerca del destino, realiza la acción correspondiente
        // add(NotifyDriverArrivalAtDestination());
        if (!state.isArrived) {  
          emit(
            state.copyWith(
              isArrived: true
            )
          );
        }
      } else if (state.isArrived && !isArrivedToDestination) {
        // Si el conductor se paso el punto de destino, vuelvo a deshabilitar el boton
        emit(
          state.copyWith(
            isArrived: false
          )
        );
      }

      // Modifico la posicion del marker en el mapa
      add(AddMarkerPositionDriver(lat: event.position.latitude, lng: event.position.longitude));
      
      // Actualizando la posicion de la camara en el mapa segun la ubicacion del usuario
      add(ChangeMapCameraPosition(lat: event.position.latitude, lng: event.position.longitude));
      
      // Actualizando el tiempo de llegada y distancia al destino
      add(GetTimeAndDistanceValues(
        driverLat: event.position.latitude, 
        driverLng: event.position.longitude
      ));

      emit(
        state.copyWith(
          position: event.position
        )
      );

      // Actualizando la ruta del conductor hacia el punto de Destino
      // Actualizar la ruta cada vez que el conductor se mueve, genera un costo ams elevado en GoogleMaps API
      add(AddPolyline());

      // Emitimos el cambio de posicion del Driver
      add(EmitDriverPositionSocketIO());
    });

    // Detenemos el seguimiento de nuestra posicion
    on<StopLocation>((event, emit) {
      positionSubscription?.cancel();
    });

    // Agregando la ruta al mapa desde la ubicación del Driver hasta el punto de Origen del viaje
    on<AddPolyline>((event, emit) async {
      print('Entramos a AddPolyline ------------------------------------');

      if (state.position != null && state.destinationLatLng != null) {
        print('Adding AddPolyline');
        print(state.position!.latitude);
        print(state.position!.longitude);
        print(state.destinationLatLng);

        // Obteniendo las coordenadas del origen y destino
        List<LatLng> polylineCoordinates = await geolocationUseCases.getPolyline.run(
          LatLng(state.position!.latitude, state.position!.longitude), 
          state.destinationLatLng!
        );

        PolylineId id = const PolylineId("MyRoute"); // Id de la ruta
        Polyline polyline = Polyline(
          polylineId: id, 
          color: Colors.blueAccent, 
          points: polylineCoordinates, // LatLng Origen/Destino
          width: 6  // Tamaño de la ruta en el mapa
        );

        emit(
          state.copyWith(
            polylines: {
              id: polyline
            }
          )
        );
      }
    });

    // Trayendo los datos: Teimpo estimado del trayecto y Distancia del punto de origen al punto de destino
    on<GetTimeAndDistanceValues>((event, emit) async {
      print('Entramos a GetTimeAndDistanceValues ------------------------------------');
      
      emit(
        state.copyWith(
          responseTimeAndDistance: null
        )
      );

      Resource response = await driverTripRequestsUseCases.getTimeAndDistance.run(
        event.driverLat,
        event.driverLng,
        state.destinationLatLng!.latitude,
        state.destinationLatLng!.longitude,
        "now" // Utilizo 'now' para realizar los calculos en tiempo real
      );

      if (response is Success<TimeAndDistanceValues>) {    
        final data = response.data;
        print('Emitiendo TimeAndDistance');
        emit(
          state.copyWith(
            timeAndDistance: data
          )
        );
      }
    });

    // Iniciamos el viaje - Cambiamos el estado del viaje en la BD
    on<ChangeTripStatus>((event, emit) async {
      print('Entrando a ChangeTripStatus -------------------------------------');

      emit(
        state.copyWith(
          responseEndTrip: Loading(),
        )
      );

      // Actualizando el estado del viaje -> 4 = FINALIZED
      Resource updateTripStatusRes = await driverTripRequestsUseCases.updateTripStatusUseCase.run(event.idTrip.toInt(), 4);
      print( updateTripStatusRes);

      // Emitimos el estado según el resultado del Resource
      emit(
        state.copyWith(
          responseEndTrip: updateTripStatusRes,
        ),
      );
    });

    // Iniciamos el viaje - Cambiamos el estado del viaje en la BD
    on<SetTripFinished>((event, emit) async {
      print('Entrando a SetTripFinished -------------------------------------');

      emit(
        state.copyWith(
          tripFinished: event.tripFinished,
        ),
      );
    });
 
    // Emitiendo la posicion del conductor aca vez que su ubicacion cambia
    on<EmitDriverPositionSocketIO>((event, emit) async {
      print('Emitiendo la ubicación del driver >>>>>>>>>>>>>>>>>>>>>');
      print(state.position!.latitude);
      print(state.position!.longitude);
      
      if(socketIOBloc.state.socket != null) {
        double lat = double.parse(state.position!.latitude.toString()); // Ex: double.parse('-31.419881')
        double lng = double.parse(state.position!.longitude.toString()); // Ex: double.parse('-64.188243')
        socketIOBloc.state.socket?.emit('change_driver_position_trip', {
          "trip_id": state.idTrip,
          "lat": lat,
          'lng': lng
        });
      }
    });

    // Emitiendo la notificacion de viaje finalizado
    on<EmitUpdateStatusTripSocketIO>((event, emit) async {
      print('Emitiendo la finalización del viaje >>>>>>>>>>>>>>>>>>>>>');
      
      if(socketIOBloc.state.socket != null) {
        print('Emitiendo');
        socketIOBloc.state.socket?.emit('update_status_trip', {
          "trip_id": state.idTrip,
        });
      }
    });
    
    // Reseteo los valores del State al salir de pantalla
    on<ResetState>((event, emit) {
      print('reseteo');
      // Asegúrate de cancelar la suscripción antes de iniciar otra.
      positionSubscription?.cancel(); // Detenemos la suscripción existente.
      positionSubscription = null; // Restablecemos el valor.
      
      emit(const MapTripDriverState()); // Emitimos el estado inicial limpio.
    });
  }

  // Funcion para calcular los limites de la ruta, y poder realizar el movimiento de la camara
  LatLngBounds calculateBounds(LatLng pickUp, LatLng destination) {
    LatLngBounds bounds;

    if (pickUp.latitude > destination.latitude && pickUp.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: pickUp);
    } else if (pickUp.longitude > destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickUp.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, pickUp.longitude));
    } else if (pickUp.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, pickUp.longitude),
        northeast: LatLng(pickUp.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickUp, northeast: destination);
    }

    return bounds;
  }

  // Función para verificar si la posición del conductor está cerca del destino usando LatLng
  // bool _isCloseToDestination(double driverLat, double driverLng) {
  //   if (state.destinationLatLng == null) return false;

  //   double destinationLat = state.destinationLatLng!.latitude;
  //   double destinationLng = state.destinationLatLng!.longitude;

  //   // Definir un umbral de tolerancia (por ejemplo, 0.0001 grados)
  //   double tolerance = 0.0001;

  //   // Verificamos si la diferencia entre las coordenadas es menor que la tolerancia
  //   return (driverLat - destinationLat).abs() < tolerance && (driverLng - destinationLng).abs() < tolerance;
  // }


  // Función para comprobar si el conductor está cerca del destino
  bool _isCloseToDestination(Position driverPosition, LatLng destinationLatLng) {
    // Calculamos la distancia entre la posición del conductor y el destino
    double distanceInMeters = Geolocator.distanceBetween(
      driverPosition.latitude,
      driverPosition.longitude,
      destinationLatLng.latitude,
      destinationLatLng.longitude,
    );

    print('Distancia al destino: $distanceInMeters metros');

    // Validamos si la distancia es menor a 70 metros
    if (distanceInMeters <= 70) {
      print('¡El conductor está a menos de 70 metros del destino!');
      return true;  // El conductor está cerca del destino
    } else {
      return false;  // El conductor no está cerca del destino
    }
  }
}