// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

List<UserProfile> userProfileFromJson(String str) => List<UserProfile>.from(json.decode(str).map((x) => UserProfile.fromJson(x)));

String userProfileToJson(List<UserProfile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfile {
  UserProfile({
    this.fullName,
    this.email,
    this.age,
    this.gender,
    this.clubA,
    this.clubB,
    this.clubC,
    this.pasteUrl,
    this.buddy,
    this.coach,
    this.uid,
    this.sportsPlayed,
    this.verifiedClubs,
  });

  final String fullName;
  final String email;
  final String age;
  final String gender;
  final String clubA;
  final String clubB;
  final String clubC;
  final String pasteUrl;
  final String buddy;
  final String coach;
  final String uid;
  final List<String> sportsPlayed;
  final List<String> verifiedClubs;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        fullName: json["fullName"],
        email: json["email"],
        age: json["age"],
        gender: json["gender"],
        clubA: json["clubA"],
        clubB: json["clubB"],
        clubC: json["clubC"],
        pasteUrl: json["pasteUrl"],
        buddy: json["buddy"],
        coach: json["coach"],
        uid: json["uid"],
        sportsPlayed: List<String>.from(json["sportsPlayed"]?.map((x) => x)),
        verifiedClubs: List<String>.from(json["verifiedClubs"]?.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "age": age,
        "gender": gender,
        "clubA": clubA,
        "clubB": clubB,
        "clubC": clubC,
        "pasteUrl": pasteUrl,
        "buddy": buddy,
        "coach": coach,
        "uid": uid,
        "sportsPlayed": List<dynamic>.from(sportsPlayed?.map((x) => x)),
        "verifiedClubs": List<dynamic>.from(verifiedClubs?.map((x) => x)),
      };
}
