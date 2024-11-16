
import 'package:carpool_21_app/src/domain/useCases/drivers-position/createDriverPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/deleteDriverPositionUseCase.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/getDriverPositionUseCase.dart';

class DriversPositionUseCases {

  CreateDriverPositionUseCase createDriverPosition;
  DeleteDriverPositionUseCase deleteDriverPosition;
  GetDriverPositionUseCase getDriverPosition;

  DriversPositionUseCases({
    required this.createDriverPosition,
    required this.deleteDriverPosition,
    required this.getDriverPosition,
  });
}