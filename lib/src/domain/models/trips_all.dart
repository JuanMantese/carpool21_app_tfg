import 'package:carpool_21_app/src/domain/models/trip_detail.dart';

class TripsAll {
  // TripDetail? currentTrip;
  List<TripDetail> futureTrips;
  List<TripDetail> pastTrips;

  TripsAll({
    // this.currentTrip,
    required this.futureTrips,
    required this.pastTrips,
  });

  factory TripsAll.fromJson(Map<String, dynamic> json) => TripsAll(
    // currentTrip: TripDetail.fromJson(json["currentTrip"]),
    futureTrips: List<TripDetail>.from(json["futureTrips"].map((x) => TripDetail.fromJson(x))),
    pastTrips: List<TripDetail>.from(json["pastTrips"].map((x) => TripDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // 'currentTrip': currentTrip?.toJson(),
    'futureTrips': List<dynamic>.from(futureTrips.map((x) => x.toJson())),
    'pastTrips': List<dynamic>.from(pastTrips.map((x) => x.toJson())),
  };
}