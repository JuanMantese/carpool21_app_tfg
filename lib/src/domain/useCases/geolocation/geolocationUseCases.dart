
import 'package:carpool_21_app/src/domain/useCases/geolocation/createMarkerUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/findPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getLocationDataUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getMarkerUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPlacemarkDataUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPolylineUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/getPositionStreamUseCase.dart';

class GeolocationUseCases {

  FindPositionUseCase findPosition;
  CreateMarkerUseCase createMarker;
  GetMarkerUseCase getMarker;
  GetLocationDataUseCase getLocationData;
  GetPlacemarkDataUseCase getPlacemarkData;
  GetPolylineUseCase getPolyline;
  GetPositionStreamUseCase getPositionStream;

  GeolocationUseCases({
    required this.findPosition,
    required this.createMarker,
    required this.getMarker,
    required this.getLocationData,
    required this.getPlacemarkData,
    required this.getPolyline,
    required this.getPositionStream,
  });

}