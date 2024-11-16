import 'package:carpool_21_app/src/domain/models/tripDetail.dart';

class TripsAll {
  // TripDetail? currentTrip;
  List<TripDetail>? futureTrips;
  List<TripDetail>? pastTrips;

  TripsAll({
    // this.currentTrip,
    this.futureTrips,
    this.pastTrips,
  });

  factory TripsAll.fromJson(Map<String, dynamic> json) => TripsAll(
    // currentTrip: TripDetail.fromJson(json["currentTrip"]),
    futureTrips: List<TripDetail>.from(json["futureTrips"].map((x) => TripDetail.fromJson(x))),
    pastTrips: List<TripDetail>.from(json["pastTrips"].map((x) => TripDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // 'currentTrip': currentTrip?.toJson(),
    'futureTrips': futureTrips != null ? List<dynamic>.from(futureTrips!.map((x) => x.toJson())) : '',
    'pastTrips': pastTrips != null ? List<dynamic>.from(pastTrips!.map((x) => x.toJson())) : '',
  };
}