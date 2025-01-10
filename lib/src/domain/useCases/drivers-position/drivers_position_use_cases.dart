import 'package:carpool_21_app/src/domain/useCases/drivers-position/create_driver_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/delete_driver_position_use_case.dart';
import 'package:carpool_21_app/src/domain/useCases/drivers-position/get_driver_position_use_case.dart';

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