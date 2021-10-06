part of 'booking_history_cubit.dart';

abstract class BookingHistoryState extends Equatable {
  const BookingHistoryState();
}

class BookingHistoryInitial extends BookingHistoryState {
  @override
  List<Object> get props => [];
}

class BookingHistoryLoadInProgress extends BookingHistoryState {
  @override
  List<Object> get props => [];
}

class BookingHistoryLoadSuccess extends BookingHistoryState {
  final List<BookingHistory> userBookingHistory;

  BookingHistoryLoadSuccess({@required this.userBookingHistory});
  @override
  List<Object> get props => [userBookingHistory];
}

class BookingHistoryLoadFailure extends BookingHistoryState {
  @override
  List<Object> get props => [];
}
