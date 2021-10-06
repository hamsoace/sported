import 'package:flutter/material.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/data/repositories/venue_data_provider.dart';

class VenueRepository {
  final VenueDataProvider venueDataProvider;

  VenueRepository({@required this.venueDataProvider});

  //get football
  Future<List<Venue>> getFootballVenues() async {
    final venues = await venueDataProvider.getVenues();
    final footballVenues = venues.where((element) => element.sportsOfferedList.contains('Football')).toList();
    return footballVenues;
  }

  //get cricket
  Future<List<Venue>> getCricketVenues() async {
    final venues = await venueDataProvider.getVenues();
    final cricketVenues = venues.where((element) => element.sportsOfferedList.contains('Cricket')).toList();
    return cricketVenues;
  }

//get badminton
  Future<List<Venue>> getBadmintonVenues() async {
    final venues = await venueDataProvider.getVenues();
    final badmintonVenues = venues.where((element) => element.sportsOfferedList.contains('Badminton')).toList();
    return badmintonVenues;
  }

//get basketball
  Future<List<Venue>> getBasketballVenues() async {
    final venues = await venueDataProvider.getVenues();
    final basketballVenues = venues.where((element) => element.sportsOfferedList.contains('Basketball')).toList();
    return basketballVenues;
  }

//get tennis
  Future<List<Venue>> getTennisVenues() async {
    final venues = await venueDataProvider.getVenues();
    final tennisVenues = venues.where((element) => element.sportsOfferedList.contains('Tennis')).toList();
    return tennisVenues;
  }

//get swimming
  Future<List<Venue>> getSwimminglVenues() async {
    final venues = await venueDataProvider.getVenues();
    final swimmingVenues = venues.where((element) => element.sportsOfferedList.contains('Swimming')).toList();
    return swimmingVenues;
  }

//get volleyball
  Future<List<Venue>> getVolleyballVenues() async {
    final venues = await venueDataProvider.getVenues();
    final volleyballVenues = venues.where((element) => element.sportsOfferedList.contains('Volleyball')).toList();
    return volleyballVenues;
  }

//get rugby
  Future<List<Venue>> getRugbyVenues() async {
    final venues = await venueDataProvider.getVenues();
    final rugbyVenues = venues.where((element) => element.sportsOfferedList.contains('Rugby')).toList();
    return rugbyVenues;
  }

//get table tennnis
  Future<List<Venue>> getTableTennisVenues() async {
    final venues = await venueDataProvider.getVenues();
    final tableTennisVenues = venues.where((element) => element.sportsOfferedList.contains('Table Tennis')).toList();
    return tableTennisVenues;
  }

//get handball
  Future<List<Venue>> getHandballVenues() async {
    final venues = await venueDataProvider.getVenues();
    final handballVenues = venues.where((element) => element.sportsOfferedList.contains('Handball')).toList();
    return handballVenues;
  }
}
