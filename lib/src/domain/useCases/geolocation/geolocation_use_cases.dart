import 'package:carpool_21_app/src/domain/useCases/geolocation/create_marker_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/find_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_location_data_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_marker_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_placemark_data_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_polyline_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/geolocation/get_position_stream_use_case.dart';

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