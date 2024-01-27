// To parse this JSON data, do
//
//     final trajectModel = trajectModelFromMap(jsonString);

import 'dart:convert';

TrajectModel trajectModelFromMap(String str) => TrajectModel.fromMap(json.decode(str));

String trajectModelToMap(TrajectModel data) => json.encode(data.toMap());

class TrajectModel {
  DateTime date;
  Departures departures;

  TrajectModel({
    required this.date,
    required this.departures,
  });

  factory TrajectModel.fromMap(Map<String, dynamic> json) => TrajectModel(
    date: DateTime.parse(json["date"]),
    departures: Departures.fromMap(json["departures"]),
  );

  Map<String, dynamic> toMap() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "departures": departures.toMap(),
  };
}

class Departures {
  List<Traject> traject;

  Departures({
    required this.traject,
  });

  factory Departures.fromMap(Map<String, dynamic> json) => Departures(
    traject: List<Traject>.from(json[dynamic].map((x) => Traject.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "departures": List<dynamic>.from(traject.map((x) => x.toMap())),
  };
}

class Traject {
  String id;
  String trajectTime;
  bool full;

  Traject({
    required this.id,
    required this.trajectTime,
    required this.full,
  });

  factory Traject.fromMap(Map<String, dynamic> json) => Traject(
    id: json["id"],
    trajectTime: json["trajectTime"],
    full: json["full"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "trajectTime": trajectTime,
    "full": full,
  };
}
