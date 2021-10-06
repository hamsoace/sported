import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sported_app/business_logic/blocs/nav_bloc/nav_bloc.dart';
import 'package:sported_app/business_logic/cubits/booking_history_cubit/booking_history_cubit.dart';
import 'package:sported_app/presentation/shared/pages_switcher.dart';

class SuccessfulBookDialog extends StatelessWidget {
  final String selectedDate;
  final String selectedSlot;
  const SuccessfulBookDialog({
    Key key,
    this.selectedDate,
    this.selectedSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.MMMMEEEEd().format(DateTime.parse(selectedDate));
    print(formattedDate);
    return Dialog(
      backgroundColor: Color(0xff18181A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
      child: Container(
        height: 298.h,
        width: 360.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //tick

            SizedBox(height: 30.h),
            Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff31323B),
              ),
              child: Icon(
                Icons.check,
                size: 32.r,
                color: Color(0xff9BEB81),
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'Booked Successfully!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'Your booking is confirmed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),

            RichText(
              text: TextSpan(
                text: 'See you on ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: formattedDate,
                    style: TextStyle(
                      color: Color(0xff8FD974),
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text: " at ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text: selectedSlot,
                    style: TextStyle(
                      color: Color(0xff8FD974),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 44.h),

            //done btn
            MaterialButton(
              height: 46.h,
              // minWidth: 3.w,
              color: Color(0xff8FD974),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              shape: StadiumBorder(),
              elevation: 0.0,
              hoverElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              child: Text(
                'View Booking History',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              onPressed: () {
                BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<NavBloc>(
                      create: (context) => NavBloc()..add(LoadPageTwo()),
                      child: WillPopScope(
                        onWillPop: () async => false,
                        child: PagesSwitcher(),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
