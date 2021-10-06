import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';

class BookingsGrid extends StatelessWidget {
  final List<BookingHistory> userBookingHistory;

  BookingsGrid({Key key, @required this.userBookingHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 0.0,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: userBookingHistory.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.w,
        ),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final sportName = userBookingHistory[index].sportName;
          final dateBooked = userBookingHistory[index].dateBooked;
          final formattedDate = DateFormat.MEd().format(DateTime.parse(dateBooked.toString()));

          return Container(
            width: 176.w,
            height: 216.h,
            padding: EdgeInsets.all(12.0.r),
            decoration: BoxDecoration(
              color: Color(0xff25262C),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //sports icon
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
                  color: Colors.white,
                  size: 72.r,
                ),

                SizedBox(height: 14.h),

                //venue
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userBookingHistory[index].venueName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xff8FD974),
                      fontSize: 13.sp,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                //date
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //icon
                    Icon(
                      Icons.event_note,
                      color: Color(0xff9BEB81),
                      size: 12.r,
                    ),

                    SizedBox(width: 16.w),

                    // date
                    Container(
                      width: 120.w,
                      child: Text(
                        formattedDate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
                // time
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //icon
                    Icon(
                      MdiIcons.clockTimeThreeOutline,
                      color: Color(0xff9BEB81),
                      size: 12.r,
                    ),

                    SizedBox(width: 16.w),

                    // time
                    Text(
	                    DateFormat.jm().format(DateTime.parse(userBookingHistory[index].slotBeginTime.toString())),
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
