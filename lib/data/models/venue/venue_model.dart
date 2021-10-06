import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

List<Venue> venueFromJson(String str) => List<Venue>.from(json.decode(str).map((x) => Venue.fromJson(x)));

String venueToJson(List<Venue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Venue extends Equatable {
  Venue({
    @required this.id,
    @required this.venueName,
    @required this.location,
    @required this.timeOpen,
    @required this.timeClosed,
    @required this.totalDaysOpen,
    @required this.description,
    @required this.rules,
    @required this.images,
    @required this.sportsOfferedList,
    @required this.sportsOffered,
  });

  final String venueName;
  final String timeOpen;
  final String timeClosed;
  final int totalDaysOpen;
  final String description;
  final List<String> rules;
  final List<String> images;
  final List<String> sportsOfferedList;
  final List<SportsOffered> sportsOffered;
  final GeoPoint location;
  final int id;

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["id"],
        location: json["location"],
        venueName: json["venueName"],
        timeOpen: json["timeOpen"],
        timeClosed: json["timeClosed"],
        totalDaysOpen: json["totalDaysOpen"],
        description: json["description"],
        rules: List<String>.from(json["rules"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
        sportsOfferedList: List<String>.from(json["sportsOfferedList"].map((x) => x)),
        sportsOffered: List<SportsOffered>.from(json["sportsOffered"].map((x) => SportsOffered.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "venueName": venueName,
        "timeOpen": timeOpen,
        "timeClosed": timeClosed,
        "totalDaysOpen": totalDaysOpen,
        "description": description,
        "location": location,
        "id": id,
        "rules": List<dynamic>.from(rules.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
        "sportsOfferedList": List<dynamic>.from(sportsOfferedList.map((x) => x)),
        "sportsOffered": List<dynamic>.from(sportsOffered.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [
        timeOpen,
        timeClosed,
        totalDaysOpen,
        description,
        rules,
        images,
        location,
        id,
        sportsOfferedList,
        sportsOffered,
      ];
}

class SportsOffered extends Equatable {
  SportsOffered({
    @required this.sportName,
    @required this.ratesPerHr,
    @required this.memberRatesPerHr,
  });

  final String sportName;
  final int ratesPerHr;
  final int memberRatesPerHr;

  factory SportsOffered.fromJson(Map<String, dynamic> json) => SportsOffered(
        sportName: json["sportName"],
        ratesPerHr: json["ratesPerHr"],
        memberRatesPerHr: json["memberRatesPerHr"],
      );

  Map<String, dynamic> toJson() => {
        "sportName": sportName,
        "ratesPerHr": ratesPerHr,
        "memberRatesPerHr": memberRatesPerHr,
      };

  @override
  List<Object> get props => [
        sportName,
        ratesPerHr,
        memberRatesPerHr,
      ];
}
