import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';

class BookingHistoryDataProvider {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<BookingHistory>> getBookingHistory() async {
    return await firestore.collection('booking_history').get().then((value) => value.docs.map((e) => BookingHistory.fromJson(e.data())).toList());
  }
}
