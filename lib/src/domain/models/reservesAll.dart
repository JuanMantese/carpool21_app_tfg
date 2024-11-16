import 'package:carpool_21_app/src/domain/models/reserveDetail.dart';


class ReservesAll {
  // ReserveDetail currentReserve;
  List<ReserveDetail> futureReservations;
  List<ReserveDetail> pastReservations;

  ReservesAll({
    // required this.currentReserve,
    required this.futureReservations,
    required this.pastReservations,
  });

  factory ReservesAll.fromJson(Map<String, dynamic> json) => ReservesAll(
    // currentReserve: ReserveDetail.fromJson(json["currentReserve"]),
    futureReservations: List<ReserveDetail>.from(json["futureReservations"].map((x) => ReserveDetail.fromJson(x))),
    pastReservations: List<ReserveDetail>.from(json["pastReservations"].map((x) => ReserveDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // 'currentReserve': currentReserve.toJson(),
    'futureReservations': List<dynamic>.from(futureReservations.map((x) => x.toJson())),
    'pastReservations': List<dynamic>.from(pastReservations.map((x) => x.toJson())),
  };
}