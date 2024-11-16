import 'dart:convert';

TimeAndDistanceValues timeAndDistanceValuesFromJson(String str) => TimeAndDistanceValues.fromJson(json.decode(str));

String timeAndDistanceValuesToJson(TimeAndDistanceValues data) => json.encode(data.toJson());

// Tiempo (Duracion del vaije) y Disntacia del viaje (del punto de origen al punto de fin)
class TimeAndDistanceValues {
  double tripPrice;
  // String destinationAddresses;
  // String originAddresses;
  Distance distance;
  Duration duration;

  TimeAndDistanceValues({
    required this.tripPrice,
    // required this.destinationAddresses,
    // required this.originAddresses,
    required this.distance,
    required this.duration,
  });

  factory TimeAndDistanceValues.fromJson(Map<String, dynamic> json) => TimeAndDistanceValues(
    tripPrice: json["trip_price"]?.toDouble(),
    // destinationAddresses: json["destination_addresses"],
    // originAddresses: json["origin_addresses"],
    distance: Distance.fromJson(json["distance"]),
    duration: Duration.fromJson(json["duration"]),
  );

  Map<String, dynamic> toJson() => {
    "trip_price": tripPrice,
    // "destination_addresses": destinationAddresses,
    // "origin_addresses": originAddresses,
    "distance": distance.toJson(),
    "duration": duration.toJson(),
  };
}

class Distance {
  String text;
  double value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    text: json["text"],
    value: json["value"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}

class Duration {
  String text;
  double value;

  Duration({
    required this.text,
    required this.value,
  });

  factory Duration.fromJson(Map<String, dynamic> json) => Duration(
    text: json["text"],
    value: json["value"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}