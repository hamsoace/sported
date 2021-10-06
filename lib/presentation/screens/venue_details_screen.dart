import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';

class VenueDetailsScreen extends StatelessWidget {
  final Venue venue;

  const VenueDetailsScreen({Key key, @required this.venue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              //images
              SliverAppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                collapsedHeight: 240.h,
                toolbarHeight: 48.h,
                titleSpacing: 0.0,
                floating: true,

                //images swiper
                flexibleSpace: Swiper(
                  loop: true,
                  outer: false,
                  itemCount: venue.images.length,
                  indicatorLayout: PageIndicatorLayout.COLOR,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20.0.h),
                    builder: DotSwiperPaginationBuilder(
                      size: 6,
                      space: 5,
                      color: Color(0xff9AFAA8),
                      activeColor: Colors.white,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final image = venue.images[index];
                    return Container(
                      height: 240.h,
                      width: 1.sw,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xff18181A),
                          ],
                        ),
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.fitWidth,
                        filterQuality: FilterQuality.low,
                        loadingBuilder: (_, __, ___) {
                          if (___ == null) return __;
                          return SpinKitRipple(
                            color: Color(0xff8FD974),
                            size: 48.r,
                          );
                        },
                      ),
                    );
                  },
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: 18.r,
                    color: Colors.white,
                  ),
                ),
              ),

              //details
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //venue name
                          Text(
                            venue.venueName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22.sp,
                            ),
                          ),

                          //venue desc
                          Text(
                            venue.description,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Color(0xBF707070),
                            ),
                          ),

                          SizedBox(height: 10.h),

                          //facilities title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage('assets/icons/facilities_icon.png'),
                                color: Color(0xff8FD974),
                                size: 24.r,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Facilities',
                                style: regularStyle,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          Container(
                            height: 80.h,
                            width: 1.sw,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: venue.sportsOffered.length,
                              itemBuilder: (BuildContext context, int index) {
                                final sportName = venue.sportsOffered[index].sportName;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //sport
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
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
                                              color: Color(0xff838384),
                                              size: 25.r,
                                            ),
                                            SizedBox(height: 2.0.h),
                                            Text(
                                              venue.sportsOffered[index].sportName,
                                              style: labelStyle.copyWith(fontSize: 9.sp),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              venue.sportsOffered[index].ratesPerHr.toString() + " KES/hr",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Color(0xff9BEB81),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20.w),
                                  ],
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),

                          //divider
                          Divider(height: 1.h, thickness: 1.h, color: Color(0xff707070)),

                          SizedBox(height: 20.h),

                          //amenities title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage('assets/icons/amenities_icon.png'),
                                color: Color(0xff8FD974),
                                size: 24.r,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Amenities',
                                style: regularStyle,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          //amenities
                          Container(
                            width: 0.5.sw,
                            padding: EdgeInsets.only(left: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ImageIcon(
                                  AssetImage('assets/icons/shower_icon.png'),
                                  color: Color(0xffA5A5A8),
                                  size: 15.r,
                                ),
                                SizedBox(width: 10.w),
                                ImageIcon(
                                  AssetImage('assets/icons/wifi_icon.png'),
                                  color: Color(0xffA5A5A8),
                                  size: 15.r,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          //divider
                          Divider(height: 1.h, thickness: 1.h, color: Color(0xff707070)),

                          SizedBox(height: 20.h),

                          //rules title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_outlined,
                                size: 24.r,
                                color: Color(
                                  0xff8FD974,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Rules & Regulations',
                                style: regularStyle,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          //rules
                          Container(
                            height: 100.h,
                            child: ListView.builder(
                              itemCount: venue.rules.length,
                              itemBuilder: (context, index) {
                                final rule = venue.rules[index];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        //indicator
                                        Icon(
                                          MdiIcons.circleOutline,
                                          size: 10.r,
                                          color: Color(0xff9BEB81),
                                        ),

                                        SizedBox(width: 10.w),

                                        //rule
                                        SizedBox(
                                          width: 362.w,
                                          child: Text(
                                            rule,
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Color(0xBF707070),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0.h),
                                  ],
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 16.0.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
