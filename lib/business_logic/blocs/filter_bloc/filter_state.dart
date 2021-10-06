part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();
}

class FilterInitial extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterLoading extends FilterState {
  @override
  List<Object> get props => [];
}

class FilterFailure extends FilterState {
  @override
  List<Object> get props => [];
}

class FootballLoaded extends FilterState {
  final List<Venue> footballVenues;

  FootballLoaded({@required this.footballVenues});
  @override
  List<Object> get props => [footballVenues];
}

class CricketLoaded extends FilterState {
  final List<Venue> cricketVenues;

  CricketLoaded({@required this.cricketVenues});

  @override
  List<Object> get props => [cricketVenues];
}

class BadmintonLoaded extends FilterState {
  final List<Venue> badmintonVenues;

  BadmintonLoaded({@required this.badmintonVenues});

  @override
  List<Object> get props => [badmintonVenues];
}

class BasketballLoaded extends FilterState {
  final List<Venue> basketballVenues;

  BasketballLoaded({@required this.basketballVenues});

  @override
  List<Object> get props => [basketballVenues];
}

class TennisLoaded extends FilterState {
  final List<Venue> tennisVenues;

  TennisLoaded({@required this.tennisVenues});

  @override
  List<Object> get props => [tennisVenues];
}

class SwimmingLoaded extends FilterState {
  final List<Venue> swimmingVenues;

  SwimmingLoaded({@required this.swimmingVenues});

  @override
  List<Object> get props => [swimmingVenues];
}

class VolleyballLoaded extends FilterState {
  final List<Venue> volleyballVenues;

  VolleyballLoaded({@required this.volleyballVenues});

  @override
  List<Object> get props => [volleyballVenues];
}

class RugbyLoaded extends FilterState {
  final List<Venue> rugbyVenues;

  RugbyLoaded({@required this.rugbyVenues});

  @override
  List<Object> get props => [rugbyVenues];
}

class TableTennisLoaded extends FilterState {
  final List<Venue> tableTennisVenues;

  TableTennisLoaded({@required this.tableTennisVenues});

  @override
  List<Object> get props => [tableTennisVenues];
}

class HandballLoaded extends FilterState {
  final List<Venue> handballVenues;

  HandballLoaded({@required this.handballVenues});

  @override
  List<Object> get props => [handballVenues];
}
