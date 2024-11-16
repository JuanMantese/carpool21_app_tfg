
import 'package:carpool_21_app/src/data/dataSource/remote/services/reserveService.dart';
import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';
import 'package:carpool_21_app/src/domain/models/reserveRequest.dart';
import 'package:carpool_21_app/src/domain/models/reservesAll.dart';
import 'package:carpool_21_app/src/domain/repository/reserveRepository.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';

class ReserveRepositoryImpl implements ReserveRepository {

  ReserveService reserveService;

  ReserveRepositoryImpl(this.reserveService);

  @override
  Future<Resource<ReserveDetail>> create(ReserveRequest reserveRequest) {
    return reserveService.create(reserveRequest);
  }

  @override
  Future<Resource<ReserveDetail>> getReserveDetail(int idReserve) {
    return reserveService.getReserveDetail(idReserve);
  }

  @override
  Future<Resource<ReservesAll>> getMyAllReserves() {
    return reserveService.getMyReservesAll();
  }

}