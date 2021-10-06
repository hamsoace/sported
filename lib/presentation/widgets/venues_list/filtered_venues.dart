import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:sported_app/business_logic/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/presentation/screens/book_slot_screen.dart';
import 'package:sported_app/presentation/screens/venue_details_screen.dart';

class FilteredVenues extends StatelessWidget {
  final List<Venue> filteredVenues;
  final String sportToBook;
  const FilteredVenues({
    Key key,
    @required this.filteredVenues,
    @required this.sportToBook,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w),
      child: Container(
        height: 1.sh,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredVenues.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final venue = filteredVenues[index];
            //each tile
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VenueDetailsScreen(venue: venue),
                    ),
                  );
                },
                child: Container(
                  height: 104.h,
                  padding: EdgeInsets.only(top: 10.h, left: 10.0.w),
                  decoration: BoxDecoration(
                    color: Color(0xff25262B),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //image name sports
                      Container(
                        height: 59.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //image
                            Container(
                              width: 67.0.w,
                              height: 59.h,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.network(
                                venue.images[0],
                                loadingBuilder: (_, __, ___) {
                                  if (___ == null) return __;
                                  return SpinKitRipple(
                                    color: Color(0xff8FD974),
                                    size: 20.r,
                                  );
                                },
                                fit: BoxFit.fitHeight,
                              ),
                            ),

                            SizedBox(width: 8.0.w),

                            //name & sports
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name
                                Text(
                                  venue.venueName,
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff8B8B8B),
                                  ),
                                ),

                                //sports

                                Container(
                                  height: 31.h,
                                  width: 235.w,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: venue.sportsOffered.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final sportName = venue.sportsOffered[index].sportName;
                                      return BlocBuilder<FilterBloc, FilterState>(
                                        builder: (context, state) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //sport
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      sportName == "Football"
                                                          ? 'assets/icons/football_icon.png'
                                                          : sportName == 'Table Tennis'
                                                              ? 'assets/icons/table_tennis_icon.png'
                                                              : sportName == "Badminton"
                                                                  ? 'assets/icons/badminton_icon.png'
                                                                  : sportName == 'Volleyball'
                                                                      ? 'assets/icons/volleyball_icon.png'
                                                                      : sportName == "Handball"
                                                                          ? 'assets/icons/handball_icon.png'
                                                                          : sportName == 'Swimming'
                                                                              ? 'assets/icons/swimming_icon.png'
                                                                              : sportName == 'Tennis'
                                                                                  ? 'assets/icons/tennis_icon.png'
                                                                                  : sportName == 'Rugby'
                                                                                      ? 'assets/icons/rugby_icon.png'
                                                                                      : sportName == 'Cricket'
                                                                                          ? 'assets/icons/cricket_icon.png'
                                                                                          : sportName == "Basketball"
                                                                                              ? 'assets/icons/basketball_icon.png'
                                                                                              : '',
                                                    ),
                                                    color: state is FootballLoaded && sportName == 'Football'
                                                        ? Color(0xff8FD974)
                                                        : state is VolleyballLoaded && sportName == 'Volleyball'
                                                            ? Color(0xff8FD974)
                                                            : state is TableTennisLoaded && sportName == 'Table Tennis'
                                                                ? Color(0xff8FD974)
                                                                : state is CricketLoaded && sportName == 'Cricket'
                                                                    ? Color(0xff8FD974)
                                                                    : state is BadmintonLoaded && sportName == 'Badminton'
                                                                        ? Color(0xff8FD974)
                                                                        : state is HandballLoaded && sportName == 'Handball'
                                                                            ? Color(0xff8FD974)
                                                                            : state is SwimmingLoaded && sportName == 'Swimming'
                                                                                ? Color(0xff8FD974)
                                                                                : state is TennisLoaded && sportName == 'Tennis'
                                                                                    ? Color(0xff8FD974)
                                                                                    : state is BasketballLoaded && sportName == 'Basketball'
                                                                                        ? Color(0xff8FD974)
                                                                                        : state is RugbyLoaded && sportName == 'Rugby'
                                                                                            ? Color(0xff8FD974)
                                                                                            : Colors.white,
                                                    size: 18.r,
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  Text(
                                                    sportName,
                                                    style: labelStyle.copyWith(fontSize: 9.sp),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 4.w),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //price time book btn
                      Container(
                        height: 27.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //price
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              builder: (context, profileState) {
                                if (profileState is EditProfileLoadSuccess) {
                                  final bool isMember = profileState.userProfile.verifiedClubs.contains(venue.venueName);
                                  final sportOffered = venue.sportsOffered.singleWhere((element) => element.sportName == sportToBook);

                                  return Text(
                                    isMember
                                        ? sportOffered.memberRatesPerHr == 0
                                            ? 'Free'
                                            : '${sportOffered.memberRatesPerHr} KES/hr'
                                        : '${sportOffered.ratesPerHr} KES/hr',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                            //time range & book
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //time range
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //day
                                    Text(
                                      venue.totalDaysOpen == 7
                                          ? 'Mon - Sun'
                                          : venue.totalDaysOpen == 6
                                              ? 'Mon - Sat'
                                              : venue.totalDaysOpen == 5
                                                  ? 'Mon - Fri'
                                                  : venue.totalDaysOpen == 2
                                                      ? 'Sat - Sun'
                                                      : '',
                                      style: labelStyle.copyWith(fontSize: 8.5.sp),
                                    ),
                                    SizedBox(height: 2.h),

                                    //time
                                    RichText(
                                      text: TextSpan(
                                        text: "${venue.timeOpen} hrs - ",
                                        style: labelStyle.copyWith(fontSize: 8.5.sp),
                                        children: [
                                          TextSpan(
                                            text: "${venue.timeClosed} hrs",
                                            style: labelStyle.copyWith(fontSize: 8.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(width: 7.w),

                                //book
                                MaterialButton(
                                  height: 24.h,
                                  minWidth: 69.w,
                                  padding: EdgeInsets.all(0),
                                  elevation: 0.0,
                                  onPressed: venue.description.contains("[NOT_BOOKABLE]")
                                      ? () {}
                                      : () {
                                          final sportBookingInfo = venue.sportsOffered.singleWhere((element) => element.sportName == sportToBook);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => BookSlotScreen(sportBookingInfo: sportBookingInfo, venue: venue),
                                            ),
                                          );
                                        },
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  color: venue.description.contains("[NOT_BOOKABLE]") ? Color(0xff38393e) : Color(0xff8FD974),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      bottomRight: Radius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Book',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: venue.description.contains("[NOT_BOOKABLE]") ? Colors.white38 : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
