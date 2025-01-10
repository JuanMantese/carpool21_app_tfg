
import 'package:carpool_21_app/src/data/dataSource/remote/services/reserve_service.dart';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/reserve_request.dart';
import 'package:carpool_21_app/src/domain/models/reserves_all.dart';
import 'package:carpool_21_app/src/domain/repository/reserve_repository.dart';
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