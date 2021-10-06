import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/data/repositories/venue_repository.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final VenueRepository venueRepository;
  FilterBloc({@required this.venueRepository})
      : assert(venueRepository != null),
        super(FilterInitial());

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is LoadFootball) {
      try {
        yield FilterLoading();
        final footballVenues = await venueRepository.getFootballVenues();
        yield FootballLoaded(footballVenues: footballVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadCricket) {
      try {
        yield FilterLoading();
        final cricketVenues = await venueRepository.getCricketVenues();
        yield CricketLoaded(cricketVenues: cricketVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadBadminton) {
      try {
        yield FilterLoading();
        final badmintonVenues = await venueRepository.getBadmintonVenues();
        yield BadmintonLoaded(badmintonVenues: badmintonVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadBasketball) {
      try {
        yield FilterLoading();
        final basketballVenues = await venueRepository.getBasketballVenues();
        yield BasketballLoaded(basketballVenues: basketballVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadTennis) {
      try {
        yield FilterLoading();
        final tennisVenues = await venueRepository.getTennisVenues();
        yield TennisLoaded(tennisVenues: tennisVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadSwimming) {
      try {
        yield FilterLoading();
        final swimmingVenues = await venueRepository.getSwimminglVenues();
        yield SwimmingLoaded(swimmingVenues: swimmingVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadVolleyball) {
      try {
        yield FilterLoading();
        final volleyballVenues = await venueRepository.getVolleyballVenues();
        yield VolleyballLoaded(volleyballVenues: volleyballVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadRugby) {
      try {
        yield FilterLoading();
        final rugbyVenues = await venueRepository.getRugbyVenues();
        yield RugbyLoaded(rugbyVenues: rugbyVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadTableTennis) {
      try {
        yield FilterLoading();
        final tableTennisVenues = await venueRepository.getTableTennisVenues();
        yield TableTennisLoaded(tableTennisVenues: tableTennisVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
    if (event is LoadHandball) {
      try {
        yield FilterLoading();
        final handballVenues = await venueRepository.getHandballVenues();
        yield HandballLoaded(handballVenues: handballVenues);
      } catch (_) {
        print(_);
        yield FilterFailure();
      }
    }
  }
}
