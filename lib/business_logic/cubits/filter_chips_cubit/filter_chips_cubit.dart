import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_chips_state.dart';

class FilterChipsCubit extends Cubit<FilterChipsState> {
  FilterChipsCubit() : super(FilterChipsInitial());
}
