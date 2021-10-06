// To parse this JSON data, do
//
//     final bookingHistory = bookingHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

List<BookingHistory> bookingHistoryFromJson(String str) => List<BookingHistory>.from(json.decode(str).map((x) => BookingHistory.fromJson(x)));

String bookingHistoryToJson(List<BookingHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingHistory {
  BookingHistory({
    @required this.venueName,
    @required this.pricePaid,
    @required this.ratesPerHr,
    @required this.memberRatesPerHr,
    @required this.dateBooked,
    @required this.slotEndTime,
    @required this.slotBeginTime,
    @required this.duration,
    @required this.sportName,
    @required this.uid,
  });

  final String venueName;
  final String pricePaid;
  final String ratesPerHr;
  final String memberRatesPerHr;
  final String slotEndTime;
  final String slotBeginTime;
  final double duration;
  final String dateBooked;
  final String sportName;
  final String uid;

  factory BookingHistory.fromJson(Map<String, dynamic> json) => BookingHistory(
        venueName: json["venueName"],
        pricePaid: json["pricePaid"],
        memberRatesPerHr: json["memberRatesPerHr"],
        ratesPerHr: json["ratesPerHr"],
        dateBooked: json["dateBooked"],
        slotBeginTime: json["slotBeginTime"],
        slotEndTime: json["slotEndTime"],
        duration: json["duration"],
        sportName: json["sportName"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "venueName": venueName,
        "pricePaid": pricePaid,
        "duration": duration,
        "memberRatesPerHr": memberRatesPerHr,
        "ratesPerHr": ratesPerHr,
        "dateBooked": dateBooked,
        "slotEndTime": slotEndTime,
        "slotBeginTime": slotBeginTime,
        "sportName": sportName,
        "uid": uid,
      };
}
