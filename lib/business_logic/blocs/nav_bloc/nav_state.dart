part of 'nav_bloc.dart';

abstract class NavState extends Equatable {
  const NavState();
}

class LoadedPageOne extends NavState {
  final int index = 0;
  @override
  List<Object> get props => [index];
}

class LoadedPageTwo extends NavState {
  final int index = 1;
  @override
  List<Object> get props => [index];
}

class LoadedPageThree extends NavState {
  final int index = 2;
  @override
  List<Object> get props => [index];
}

class LoadedPageFour extends NavState {
  final int index = 3;
  @override
  List<Object> get props => [index];
}

class LoadedPageFive extends NavState {
  final int index = 3;
  @override
  List<Object> get props => [index];
}

class LoadedVenuesPage extends NavState {
  @override
  List<Object> get props => [];
}
