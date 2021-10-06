import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';
import 'package:sported_app/data/repositories/booking_history_repository.dart';

part 'booking_history_state.dart';

class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  final BookingHistoryRepository bookingHistoryRepository;
  BookingHistoryCubit({@required this.bookingHistoryRepository}) : super(BookingHistoryInitial());

  Future<void> loadBookingHistory() async {
    try {
      emit(BookingHistoryLoadInProgress());
      final userBookingHistory = await bookingHistoryRepository.fetchUserBookingHistory();
      emit(BookingHistoryLoadSuccess(userBookingHistory: userBookingHistory));
    } catch (_) {
      emit(BookingHistoryLoadFailure());
      print(_.toString());
    }
  }
}
