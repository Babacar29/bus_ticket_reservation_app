// To parse this JSON data, do
//
//     final ticket = ticketFromMap(jsonString);

import 'dart:convert';

Ticket ticketFromMap(String str) => Ticket.fromMap(json.decode(str));

String ticketToMap(Ticket data) => json.encode(data.toMap());

class Ticket {
  String id;
  String externalId;
  String departureCity;
  String arrivalCity;
  String departureBusStation;
  String arrivalBusStation;
  DateTime departureDate;
  String departureTime;
  DateTime departureDateTime;
  String billId;
  String paymentStatus;
  Passenger passenger;
  String hash;
  String commandId;
  int seatNumber;

  Ticket({
    required this.id,
    required this.externalId,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureBusStation,
    required this.arrivalBusStation,
    required this.departureDate,
    required this.departureTime,
    required this.departureDateTime,
    required this.billId,
    required this.paymentStatus,
    required this.passenger,
    required this.hash,
    required this.commandId,
    required this.seatNumber,
  });

  factory Ticket.fromMap(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    externalId: json["externalId"],
    departureCity: json["departureCity"],
    arrivalCity: json["arrivalCity"],
    departureBusStation: json["departureBusStation"],
    arrivalBusStation: json["arrivalBusStation"],
    departureDate: DateTime.parse(json["departureDate"]),
    departureTime: json["departureTime"],
    departureDateTime: DateTime.parse(json["departureDateTime"]),
    billId: json["billId"],
    paymentStatus: json["paymentStatus"],
    passenger: Passenger.fromMap(json["passenger"]),
    hash: json["hash"],
    commandId: json["commandId"],
    seatNumber: json["seatNumber"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "externalId": externalId,
    "departureCity": departureCity,
    "arrivalCity": arrivalCity,
    "departureBusStation": departureBusStation,
    "arrivalBusStation": arrivalBusStation,
    "departureDate": "${departureDate.year.toString().padLeft(4, '0')}-${departureDate.month.toString().padLeft(2, '0')}-${departureDate.day.toString().padLeft(2, '0')}",
    "departureTime": departureTime,
    "departureDateTime": departureDateTime.toIso8601String(),
    "billId": billId,
    "paymentStatus": paymentStatus,
    "passenger": passenger.toMap(),
    "hash": hash,
    "commandId": commandId,
    "seatNumber": seatNumber,
  };
}

class Passenger {
  String lastName;
  String firstName;

  Passenger({
    required this.lastName,
    required this.firstName,
  });

  factory Passenger.fromMap(Map<String, dynamic> json) => Passenger(
    lastName: json["lastName"],
    firstName: json["firstName"],
  );

  Map<String, dynamic> toMap() => {
    "lastName": lastName,
    "firstName": firstName,
  };
}
