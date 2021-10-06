import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(LoadedPageOne());

  @override
  Stream<NavState> mapEventToState(NavEvent event) async* {
    if (event is LoadPageOne) {
      yield LoadedPageOne();
    }
    if (event is LoadPageTwo) {
      yield LoadedPageTwo();
    }
    if (event is LoadPageThree) {
      yield LoadedPageThree();
    }
    if (event is LoadPageFour) {
      yield LoadedPageFour();
    }
    if (event is LoadPageFive) {
      yield LoadedPageFive();
    }
    if (event is LoadVenuesPage) {
      yield LoadedVenuesPage();
    }
  }
}
