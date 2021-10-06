import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/presentation/shared/custom_snackbar.dart';
import 'package:sported_app/presentation/widgets/payment/successfully_booked_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final String selectedDate;
  final SportsOffered sportBookingInfo;
  final String selectedBeginTime;
  final String selectedEndTime;
  final Venue venue;
  final double slotDuration;
  final String pricePaid;
  final String checkoutId;

  PaymentScreen({
    @required this.selectedDate,
    @required this.selectedBeginTime,
    @required this.venue,
    @required this.sportBookingInfo,
    @required this.checkoutId,
    @required this.selectedEndTime,
    @required this.slotDuration,
    @required this.pricePaid,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentReference paymentsRef;
  String mUserMail = "kokodavid78@gmail.com";
  QuerySnapshot payment;
  String navigateBack = 'press confirm';

  _updateBookingHistory() {
    final selectedDateTime = DateTime.parse(widget.selectedDate);

    final DateTime bookedBeginDateTime = widget.selectedBeginTime == '6:00 AM'
        ? selectedDateTime.add(Duration(hours: 6))
        : widget.selectedBeginTime == '6:30 AM'
            ? selectedDateTime.add(Duration(hours: 6, minutes: 30))
            : widget.selectedBeginTime == '7:00 AM'
                ? selectedDateTime.add(Duration(hours: 7))
                : widget.selectedBeginTime == '7:30 AM'
                    ? selectedDateTime.add(Duration(hours: 7, minutes: 30))
                    : widget.selectedBeginTime == '8:00 AM'
                        ? selectedDateTime.add(Duration(hours: 8))
                        : widget.selectedBeginTime == '8:30 AM'
                            ? selectedDateTime.add(Duration(hours: 8, minutes: 30))
                            : widget.selectedBeginTime == '9:00 AM'
                                ? selectedDateTime.add(Duration(hours: 9))
                                : widget.selectedBeginTime == '9:30 AM'
                                    ? selectedDateTime.add(Duration(hours: 9, minutes: 30))
                                    : widget.selectedBeginTime == '10:00 AM'
                                        ? selectedDateTime.add(Duration(hours: 10))
                                        : widget.selectedBeginTime == '10:30 AM'
                                            ? selectedDateTime.add(Duration(hours: 10, minutes: 30))
                                            : widget.selectedBeginTime == '11:00 AM'
                                                ? selectedDateTime.add(Duration(hours: 11))
                                                : widget.selectedBeginTime == '11:30 AM'
                                                    ? selectedDateTime.add(Duration(hours: 11, minutes: 30))
                                                    : widget.selectedBeginTime == '12:00 PM'
                                                        ? selectedDateTime.add(Duration(hours: 12))
                                                        : widget.selectedBeginTime == '12:30 PM'
                                                            ? selectedDateTime.add(Duration(hours: 12, minutes: 30))
                                                            : widget.selectedBeginTime == '1:00 PM'
                                                                ? selectedDateTime.add(Duration(hours: 13))
                                                                : widget.selectedBeginTime == '1:30 PM'
                                                                    ? selectedDateTime.add(Duration(hours: 13, minutes: 30))
                                                                    : widget.selectedBeginTime == '2:00 PM'
                                                                        ? selectedDateTime.add(Duration(hours: 14))
                                                                        : widget.selectedBeginTime == '2:30 PM'
                                                                            ? selectedDateTime.add(Duration(hours: 14, minutes: 30))
                                                                            : widget.selectedBeginTime == '3:00 PM'
                                                                                ? selectedDateTime.add(Duration(hours: 15))
                                                                                : widget.selectedBeginTime == '3:30 PM'
                                                                                    ? selectedDateTime.add(Duration(hours: 15, minutes: 30))
                                                                                    : widget.selectedBeginTime == '4:00 PM'
                                                                                        ? selectedDateTime.add(Duration(hours: 16))
                                                                                        : widget.selectedBeginTime == '4:30 PM'
                                                                                            ? selectedDateTime.add(Duration(hours: 16, minutes: 30))
                                                                                            : widget.selectedBeginTime == '5:00 PM'
                                                                                                ? selectedDateTime.add(Duration(hours: 17))
                                                                                                : widget.selectedBeginTime == '5:30 PM'
                                                                                                    ? selectedDateTime.add(Duration(hours: 17, minutes: 30))
                                                                                                    : widget.selectedBeginTime == '6:00 PM'
                                                                                                        ? selectedDateTime.add(Duration(hours: 18))
                                                                                                        : widget.selectedBeginTime == '6:30 PM'
                                                                                                            ? selectedDateTime
                                                                                                                .add(Duration(hours: 18, minutes: 30))
                                                                                                            : widget.selectedBeginTime == '7:00 PM'
                                                                                                                ? selectedDateTime.add(Duration(hours: 19))
                                                                                                                : widget.selectedBeginTime == '7:30 PM'
                                                                                                                    ? selectedDateTime
                                                                                                                        .add(Duration(hours: 19, minutes: 30))
                                                                                                                    : widget.selectedBeginTime == '8:00 PM'
                                                                                                                        ? selectedDateTime
                                                                                                                            .add(Duration(hours: 20))
                                                                                                                        : widget.selectedBeginTime == '8:30 PM'
                                                                                                                            ? selectedDateTime.add(Duration(
                                                                                                                                hours: 20, minutes: 30))
                                                                                                                            : widget.selectedBeginTime ==
                                                                                                                                    '9:00 PM'
                                                                                                                                ? selectedDateTime
                                                                                                                                    .add(Duration(hours: 21))
                                                                                                                                : widget.selectedBeginTime ==
                                                                                                                                        '9:30 PM'
                                                                                                                                    ? selectedDateTime.add(
                                                                                                                                        Duration(
                                                                                                                                            hours: 21,
                                                                                                                                            minutes: 30))
                                                                                                                                    : "";

    final DateTime bookedEndDateTime = widget.slotDuration.toString().endsWith('.5')
        ? bookedBeginDateTime.add(Duration(hours: int.parse(widget.slotDuration.toString().split('.').first), minutes: 30))
        : bookedBeginDateTime.add(Duration(hours: widget.slotDuration.toInt()));

    print('bookedEndDateTime ------------------------------ | $bookedEndDateTime');
    final uid = FirebaseAuth.instance.currentUser.uid;
    Map<String, dynamic> bookingHistory = {
      "venueName": widget.venue.venueName,
      "pricePaid": widget.pricePaid,
      "ratesPerHr": widget.sportBookingInfo.ratesPerHr.toString(),
      "memberRatesPerHr": widget.sportBookingInfo.memberRatesPerHr.toString(),
      "dateBooked": selectedDateTime.toString(),
      "slotBeginTime": bookedBeginDateTime.toString(),
      "slotEndTime": bookedEndDateTime.toString(),
      "duration": widget.slotDuration,
      "sportName": widget.sportBookingInfo.sportName,
      "customer_name": "",
      "receiptNumber": "",
      "uid": uid,
    };

    FirebaseFirestore.instance.collection('booking_history').add(bookingHistory);
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: SuccessfulBookDialog(
          // dialogContext:context,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedBeginTime,
        ),
      ),
    );
    print({"date | ${widget.selectedDate}"});
  }

  paymentConfirm() async {
    if (await FirebaseFirestore.instance
        .collection("lost_found_receipts")
        .doc("deposit_info")
        .collection("all")
        .doc(widget.checkoutId)
        .get()
        .then((value) => value.exists == true)) {
      setState(() {
        navigateBack = 'do not navigate back';
      });
      return _updateBookingHistory();
    } else {
      setState(() {
        navigateBack = 'navigate back';
      });
      showCustomSnackbar("Payment not successful. You haven\'t booked this slot. Try again", _scaffoldKey);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (navigateBack == "press confirm") {
            showCustomSnackbar('Press Confirm to check the status of your booking', _scaffoldKey);
            return false;
          } else if (navigateBack == 'navigate back') {
            Navigator.pop(context);
            return true;
          }
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color(0xff18181A),
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                navigateBack == "press confirm"
                    ? showCustomSnackbar('Press Confirm to check the status of your booking', _scaffoldKey)
                    : navigateBack == 'navigate back'
                        ? Navigator.pop(context)
                        : navigateBack == 'do not navigate back'
                            // ignore: unnecessary_statements
                            ? null
                            // ignore: unnecessary_statements
                            : null;

                // Navigator.pop(context);
              },
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: KeyboardAvoider(
              autoScroll: true,
              focusPadding: 40.h,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 40.h),
                    //banner
                    Container(
                      height: 100.h,
                      width: 1.sw,
                      child: Image.asset(
                        'assets/images/mpesa_banner.png',
                        width: 190.w,
                      ),
                    ),

                    SizedBox(height: 80.h),
                    // guides

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CONFIRM YOUR BOOKING',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    //guides

                    Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 12.w),
                      child: Column(
                        children: [
                          //1
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: Text(
                                  'Wait for MPESA prompt to enter your PIN',
                                  softWrap: true,
                                  maxLines: 1,
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

                          //2
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: Text(
                                  'Enter your PIN to pay for the slot',
                                  softWrap: true,
                                  maxLines: 1,
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

                          //3
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: Text(
                                  'Wait for M-PESA Confirmation Message',
                                  softWrap: true,
                                  maxLines: 1,
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

                          //4
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: SizedBox(
                                  width: 330.w,
                                  child: RichText(
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Beware of ',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xBF707070),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "MPESA delays",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xBF707070),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0.h),

                          //5
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: SizedBox(
                                  width: 330.w,
                                  child: RichText(
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Press ',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xBF707070),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "CONFIRM BOOKING ",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xBF707070),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'to book your slot.',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Color(0xBF707070),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0.h),

                          //6
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: SizedBox(
                                  width: 330.w,
                                  child: RichText(
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'NOTE:',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xBF707070),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " Failure to press Confirm Booking will NOT book you a slot",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xBF707070),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0.h),

                          //7
                          Row(
                            children: [
                              //indicator
                              Icon(
                                MdiIcons.circleOutline,
                                size: 10.r,
                                color: Color(0xff9BEB81),
                              ),

                              SizedBox(width: 10.w),

                              //guide
                              SizedBox(
                                width: 330.w,
                                child: Text(
                                  'View your booking details & history',
                                  softWrap: true,
                                  maxLines: 1,
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
                      ),
                    ),

                    SizedBox(height: 35.h),

                    //proceed btn
                    MaterialButton(
                      height: 40.h,
                      minWidth: 140.w,
                      color: Color(0xff8FD974),
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0.0,
                      hoverElevation: 0,
                      disabledElevation: 0,
                      highlightElevation: 0,
                      focusElevation: 0,
                      child: Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                      onPressed: () async {
                        await paymentConfirm();
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
