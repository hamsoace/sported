import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/presentation/widgets/venues_list/filtered_venues.dart';
import 'package:sported_app/presentation/widgets/venues_list/venues_list_sports_filter.dart';

class VenuesListScreen extends StatefulWidget {
  final Venue venueModel;
  const VenuesListScreen({Key key, this.venueModel}) : super(key: key);

  @override
  _VenuesListScreenState createState() => _VenuesListScreenState();
}

class _VenuesListScreenState extends State<VenuesListScreen> {
  // Map<String, dynamic> data = {
  //   "venueName": "Nais Club",
  //   "timeOpen": "0600",
  //   "timeClosed": "2100",
  //   "totalDaysOpen": 7,
  //   "description":
  //       "The Jaffery Sports Club Ground is a cricket ground situated in Nairobi, Kenya. It hosted its first ODI international during the 2007 World Cricket League in Kenya. The Ground is owned by a sect of the Muslim community in Nairobi. Hence most of the players in the Club team are Islamic.",
  //   "rules": ["Rules will be updated"],
  //   "sportsOfferedList": ["Football", "Badminton", "Cricket", "Table Tennis", "Volleyball"],
  //   "images": [
  //     "https://fastly.4sqi.net/img/general/600x600/407721430_DGyytCXxHEvZ8ECmP_-tfAeZakOPEHb4q7pZB9imNdk.jpg",
  //     "https://lh3.googleusercontent.com/p/AF1QipPkGabgYnFBS7eaDZSh_dXh0xZ1NphZBIXL-VjF=s1600-w400",
  //     "https://fastly.4sqi.net/img/general/600x600/10778693_gxKhtXi4NS0I54e2xJUMVQSlOqoUoB1kh8E8WQh1M30.jpg"
  //   ],
  //   "sportsOffered": [
  //     {"sportName": "Football", "ratesPerHr": 4000},
  //     {"sportName": "Badminton", "ratesPerHr": 300},
  //     {"sportName": "Cricket", "ratesPerHr": 10000},
  //     {"sportName": "Volleyball", "ratesPerHr": 2000},
  //     {"sportName": "Table Tennis", "ratesPerHr": 1000}
  //   ]
  // };
  //
  // addVenue() {
  //   final ref = FirebaseFirestore.instance.collection('venues');
  //   ref.add(data);
  // }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            title: Text(
              'Venues',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                //select sports
                VenuesListSportsFilter(),

                //title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 32.w, bottom: 20.h, top: 10.h),
                    child: Text(
                      'Venues',
                      style: regularStyle,
                    ),
                  ),
                ),
                // // list of venues
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    if (state is FootballLoaded) {
                      final footballVenues = state.footballVenues;
                      return FilteredVenues(filteredVenues: footballVenues, sportToBook: 'Football');
                    }
                    if (state is CricketLoaded) {
                      final cricketVenues = state.cricketVenues;

                      return FilteredVenues(filteredVenues: cricketVenues, sportToBook: 'Cricket');
                    }
                    if (state is BadmintonLoaded) {
                      final badmintonVenues = state.badmintonVenues;
                      return FilteredVenues(filteredVenues: badmintonVenues, sportToBook: 'Badminton');
                    }
                    if (state is BasketballLoaded) {
                      final basketballVenues = state.basketballVenues;

                      return FilteredVenues(filteredVenues: basketballVenues, sportToBook: 'Basketball');
                    }
                    if (state is TennisLoaded) {
                      final tennisVenues = state.tennisVenues;
                      return FilteredVenues(filteredVenues: tennisVenues, sportToBook: 'Tennis');
                    }

                    if (state is SwimmingLoaded) {
                      final swimmingVenues = state.swimmingVenues;
                      return FilteredVenues(filteredVenues: swimmingVenues, sportToBook: 'Swimming');
                    }
                    if (state is VolleyballLoaded) {
                      final volleyballVenues = state.volleyballVenues;
                      return FilteredVenues(filteredVenues: volleyballVenues, sportToBook: 'Volleyball');
                    }
                    if (state is RugbyLoaded) {
                      final rugbyVenues = state.rugbyVenues;
                      return FilteredVenues(filteredVenues: rugbyVenues, sportToBook: 'Rugby');
                    }
                    if (state is TableTennisLoaded) {
                      final tableTennisVenues = state.tableTennisVenues;
                      return FilteredVenues(filteredVenues: tableTennisVenues, sportToBook: 'Table Tennis');
                    }
                    if (state is HandballLoaded) {
                      final handballVenues = state.handballVenues;
                      return FilteredVenues(filteredVenues: handballVenues, sportToBook: 'Handball');
                    }

                    if (state is FilterLoading) {
                      return Container(
                        height: 200.h,
                        child: Center(
                          child: SpinKitRipple(
                            color: Color(0xff9BEB81),
                          ),
                        ),
                      );
                    }

                    if (state is FilterFailure) {
                      return Container(
                        height: 500.h,
                        child: Center(
                          child: Text(
                            'Couldn\'t load venues available. Check your internet connection.',
                            style: regularStyle,
                          ),
                        ),
                      );
                    }

                    return null;
                  },
                ),
                // FilteredVenues(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
