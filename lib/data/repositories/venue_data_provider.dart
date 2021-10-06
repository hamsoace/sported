import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';

class VenueDataProvider {
  Future<List<Venue>> getVenues() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final firebaseVenues = await firestore.collection('venues').get().then((value) => value.docs.map((e) => Venue.fromJson(e.data())).toList());
    return firebaseVenues;
  }
}
