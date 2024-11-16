import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class ReserveRepository {

  // Creamos la reserva de un viaje
  Future<Resource<ReserveDetail>> create(ReserveRequest reserveRequest);

  // Obtenemos todas las reservas registradas de un pasajero
  Future<Resource<ReserveDetail>> getReserveDetail(int idReserve);

  // Obtenemos todas las reservas registradas de un pasajero
  Future<Resource<ReservesAll>> getMyAllReserves();
}