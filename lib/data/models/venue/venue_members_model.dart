// To parse this JSON data, do
//
//     final venueMembersModel = venueMembersModelFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

List<VenueMembersModel> venueMembersModelFromJson(String str) => List<VenueMembersModel>.from(json.decode(str).map((x) => VenueMembersModel.fromJson(x)));

String venueMembersModelToJson(List<VenueMembersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VenueMembersModel {
  VenueMembersModel({
    @required this.venueName,
    @required this.memberIDs,
  });

  final String venueName;
  final List<String> memberIDs;

  factory VenueMembersModel.fromJson(Map<String, dynamic> json) => VenueMembersModel(
        venueName: json["venueName"],
        memberIDs: List<String>.from(json["memberIDs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "venueName": venueName,
        "memberIDs": List<dynamic>.from(memberIDs.map((x) => x)),
      };
}
