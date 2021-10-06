import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';
import 'package:sported_app/data/repositories/booking_history_data_provider.dart';

class BookingHistoryRepository {
  final BookingHistoryDataProvider bookingHistoryDataProvider;
  BookingHistoryRepository({@required this.bookingHistoryDataProvider});

  Future<List<BookingHistory>> fetchUserBookingHistory() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final allBookingHistory = await bookingHistoryDataProvider.getBookingHistory();
    final userBookingHistory = allBookingHistory.where((element) => element.uid == uid).toList();
    return userBookingHistory;
  }
}
