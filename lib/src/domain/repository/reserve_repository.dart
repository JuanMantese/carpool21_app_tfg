import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/reserve_request.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

abstract class ReserveRepository {

  // Creamos la reserva de un viaje
  Future<Resource<ReserveDetail>> create(ReserveRequest reserveRequest);

  // Obtenemos el detalle de una reserva por su ID y perteneciente al usuario logueado
  Future<Resource<ReserveDetail>> getReserveDetail(int idReserve);

  // Obtenemos todas las reservas registradas de un pasajero
  Future<Resource<ReservesAll>> getMyAllReserves();

  // Cancelamos una reserva por su ID
  Future<Resource<ReserveDetail>> cancelReserve(int idReserve);
}