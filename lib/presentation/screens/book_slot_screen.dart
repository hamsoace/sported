import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:sported_app/business_logic/cubits/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/UserProfile.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';
import 'package:sported_app/data/models/booking/end_slots_model.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';
import 'package:sported_app/data/repositories/booking_history_data_provider.dart';
import 'package:sported_app/presentation/screens/payment_screen.dart';
import 'package:sported_app/presentation/shared/custom_snackbar.dart';
import 'package:sported_app/presentation/widgets/payment/successfully_booked_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookSlotScreen extends StatefulWidget {
  final sportBookingInfo;
  final List<BookingHistory> entireBookingHistory;
  final Venue venue;
  final BookingHistoryDataProvider bookingHistoryDataProvider;

  const BookSlotScreen({
    Key key,
    this.entireBookingHistory,
    @required this.venue,
    @required this.sportBookingInfo,
    this.bookingHistoryDataProvider,
  }) : super(key: key);

  @override
  _BookSlotScreenState createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  //keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //mpesa
  bool isBooked = false;
  bool isCheckingAvailability = false;
  DocumentReference paymentsRef;
  String mUserMail = "kokodavid78@gmail.com";
  String checkoutId;
  TextEditingController phoneNumber = TextEditingController();
  UserProfile userProfile;
  bool _initialized = false;
  bool _error = false;
  double slotDuration;

  //slots
  String selectedDate;
  String selectedBeginTime;
  String selectedEndTime;
  double selectedBeginTimeIndex;
  double selectedEndTimeIndex;
  List compareTime = [
    6,
    6.5,
    7,
    7.5,
    8,
    8.5,
    9,
    9.5,
    10,
    10.5,
    11,
    11.5,
    12,
    12.5,
    13,
    13.5,
    14,
    14.5,
    15,
    15.5,
    16,
    16.5,
    17,
    17.5,
    18,
    18.5,
    19,
    19.5,
    20,
    20.5,
    21,
    21.5,
  ];

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });

      paymentsRef = FirebaseFirestore.instance.collection('payments').doc(mUserMail);
    } catch (e) {
      print(e.toString());
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> updateAccount(String mCheckoutRequestID) {
    Map<String, String> initData = {
      'CheckoutRequestID': mCheckoutRequestID,
    };

    paymentsRef.set({"info": "$mUserMail receipts data goes here."});

    return paymentsRef
        .collection("deposit")
        .doc(mCheckoutRequestID)
        .set(initData)
        .then((value) => print("Transaction Initialized."))
        .catchError((error) => print("Failed to init transaction: $error"));
  }

  Future<dynamic> startTransaction({double amount, String phone}) async {
    dynamic transactionInitialisation;
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: "174379",
          callBackURL: Uri(scheme: "https", host: "us-central1-sportedapp-6f6d2.cloudfunctions.net", path: "paymentCallback"),
          accountReference: "payment",
          phoneNumber: phone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "Demo",
          passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      var result = transactionInitialisation as Map<String, dynamic>;

      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        print("Resulting Code: " + mResponseCode);
        if (mResponseCode == '0') {
          updateAccount(result["CheckoutRequestID"]);
          setState(() {
            checkoutId = result["CheckoutRequestID"];
          });
        }
      }
      print("RESULT: " + transactionInitialisation.toString());
    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print("Exception Caught: " + e.toString());
    }
  }

  updateBookingHistory() {
    final selectedDateTime = DateTime.parse(selectedDate);

    final DateTime bookedBeginDateTime = selectedBeginTime == '6:00 AM'
        ? selectedDateTime.add(Duration(hours: 6))
        : selectedBeginTime == '6:30 AM'
            ? selectedDateTime.add(Duration(hours: 6, minutes: 30))
            : selectedBeginTime == '7:00 AM'
                ? selectedDateTime.add(Duration(hours: 7))
                : selectedBeginTime == '7:30 AM'
                    ? selectedDateTime.add(Duration(hours: 7, minutes: 30))
                    : selectedBeginTime == '8:00 AM'
                        ? selectedDateTime.add(Duration(hours: 8))
                        : selectedBeginTime == '8:30 AM'
                            ? selectedDateTime.add(Duration(hours: 8, minutes: 30))
                            : selectedBeginTime == '9:00 AM'
                                ? selectedDateTime.add(Duration(hours: 9))
                                : selectedBeginTime == '9:30 AM'
                                    ? selectedDateTime.add(Duration(hours: 9, minutes: 30))
                                    : selectedBeginTime == '10:00 AM'
                                        ? selectedDateTime.add(Duration(hours: 10))
                                        : selectedBeginTime == '10:30 AM'
                                            ? selectedDateTime.add(Duration(hours: 10, minutes: 30))
                                            : selectedBeginTime == '11:00 AM'
                                                ? selectedDateTime.add(Duration(hours: 11))
                                                : selectedBeginTime == '11:30 AM'
                                                    ? selectedDateTime.add(Duration(hours: 11, minutes: 30))
                                                    : selectedBeginTime == '12:00 PM'
                                                        ? selectedDateTime.add(Duration(hours: 12))
                                                        : selectedBeginTime == '12:30 PM'
                                                            ? selectedDateTime.add(Duration(hours: 12, minutes: 30))
                                                            : selectedBeginTime == '1:00 PM'
                                                                ? selectedDateTime.add(Duration(hours: 13))
                                                                : selectedBeginTime == '1:30 PM'
                                                                    ? selectedDateTime.add(Duration(hours: 13, minutes: 30))
                                                                    : selectedBeginTime == '2:00 PM'
                                                                        ? selectedDateTime.add(Duration(hours: 14))
                                                                        : selectedBeginTime == '2:30 PM'
                                                                            ? selectedDateTime.add(Duration(hours: 14, minutes: 30))
                                                                            : selectedBeginTime == '3:00 PM'
                                                                                ? selectedDateTime.add(Duration(hours: 15))
                                                                                : selectedBeginTime == '3:30 PM'
                                                                                    ? selectedDateTime.add(Duration(hours: 15, minutes: 30))
                                                                                    : selectedBeginTime == '4:00 PM'
                                                                                        ? selectedDateTime.add(Duration(hours: 16))
                                                                                        : selectedBeginTime == '4:30 PM'
                                                                                            ? selectedDateTime.add(Duration(hours: 16, minutes: 30))
                                                                                            : selectedBeginTime == '5:00 PM'
                                                                                                ? selectedDateTime.add(Duration(hours: 17))
                                                                                                : selectedBeginTime == '5:30 PM'
                                                                                                    ? selectedDateTime.add(Duration(hours: 17, minutes: 30))
                                                                                                    : selectedBeginTime == '6:00 PM'
                                                                                                        ? selectedDateTime.add(Duration(hours: 18))
                                                                                                        : selectedBeginTime == '6:30 PM'
                                                                                                            ? selectedDateTime
                                                                                                                .add(Duration(hours: 18, minutes: 30))
                                                                                                            : selectedBeginTime == '7:00 PM'
                                                                                                                ? selectedDateTime.add(Duration(hours: 19))
                                                                                                                : selectedBeginTime == '7:30 PM'
                                                                                                                    ? selectedDateTime
                                                                                                                        .add(Duration(hours: 19, minutes: 30))
                                                                                                                    : selectedBeginTime == '8:00 PM'
                                                                                                                        ? selectedDateTime
                                                                                                                            .add(Duration(hours: 20))
                                                                                                                        : selectedBeginTime == '8:30 PM'
                                                                                                                            ? selectedDateTime.add(Duration(
                                                                                                                                hours: 20, minutes: 30))
                                                                                                                            : selectedBeginTime == '9:00 PM'
                                                                                                                                ? selectedDateTime
                                                                                                                                    .add(Duration(hours: 21))
                                                                                                                                : selectedBeginTime == '9:30 PM'
                                                                                                                                    ? selectedDateTime.add(
                                                                                                                                        Duration(
                                                                                                                                            hours: 21,
                                                                                                                                            minutes: 30))
                                                                                                                                    : "";

    final DateTime bookedEndDateTime = slotDuration.toString().endsWith('.5')
        ? bookedBeginDateTime.add(Duration(hours: int.parse(slotDuration.toString().split('.').first), minutes: 30))
        : bookedBeginDateTime.add(Duration(hours: slotDuration.toInt()));

    print('bookedEndDateTime ------------------------------ | $bookedEndDateTime');

    final uid = firebase_auth.FirebaseAuth.instance.currentUser.uid;
    Map<String, dynamic> bookingHistory = {
      "venueName": widget.venue.venueName,
      "pricePaid": "0.0",
      "ratesPerHr": widget.sportBookingInfo.ratesPerHr.toString(),
      "memberRatesPerHr": widget.sportBookingInfo.memberRatesPerHr.toString(),
      "dateBooked": selectedDateTime.toString(),
      "slotBeginTime": bookedBeginDateTime.toString(),
      "slotEndTime": bookedEndDateTime.toString(),
      "duration": slotDuration,
      "sportName": widget.sportBookingInfo.sportName,
      "uid": uid,
      "customer_name": "",
      "receiptNumber": "",
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
          selectedDate: selectedDate,
          selectedSlot: selectedBeginTime,
        ),
      ),
    );
  }

  validateEndSlots() {
    if (selectedBeginTime != null) {
      selectedBeginTimeIndex = selectedBeginTime == '6:00 AM'
          ? 6
          : selectedBeginTime == '6:30 AM'
              ? 6.5
              : selectedBeginTime == '7:00 AM'
                  ? 7
                  : selectedBeginTime == '7:30 AM'
                      ? 7.5
                      : selectedBeginTime == '8:00 AM'
                          ? 8
                          : selectedBeginTime == '8:30 AM'
                              ? 8.5
                              : selectedBeginTime == '9:00 AM'
                                  ? 9
                                  : selectedBeginTime == '9:30 AM'
                                      ? 9.5
                                      : selectedBeginTime == '10:00 AM'
                                          ? 10
                                          : selectedBeginTime == '10:30 AM'
                                              ? 10.5
                                              : selectedBeginTime == '11:00 AM'
                                                  ? 11
                                                  : selectedBeginTime == '11:30 AM'
                                                      ? 11.5
                                                      : selectedBeginTime == '12:00 PM'
                                                          ? 12
                                                          : selectedBeginTime == '12:30 PM'
                                                              ? 12.5
                                                              : selectedBeginTime == '1:00 PM'
                                                                  ? 13
                                                                  : selectedBeginTime == '1:30 PM'
                                                                      ? 13.5
                                                                      : selectedBeginTime == '2:00 PM'
                                                                          ? 14
                                                                          : selectedBeginTime == '2:30 PM'
                                                                              ? 14.5
                                                                              : selectedBeginTime == '3:00 PM'
                                                                                  ? 15
                                                                                  : selectedBeginTime == '3:30 PM'
                                                                                      ? 15.5
                                                                                      : selectedBeginTime == '4:00 PM'
                                                                                          ? 16
                                                                                          : selectedBeginTime == '4:30 PM'
                                                                                              ? 16.5
                                                                                              : selectedBeginTime == '5:00 PM'
                                                                                                  ? 17
                                                                                                  : selectedBeginTime == '5:30 PM'
                                                                                                      ? 17.5
                                                                                                      : selectedBeginTime == '6:00 PM'
                                                                                                          ? 18
                                                                                                          : selectedBeginTime == '6:30 PM'
                                                                                                              ? 18.5
                                                                                                              : selectedBeginTime == '7:00 PM'
                                                                                                                  ? 19
                                                                                                                  : selectedBeginTime == '7:30 PM'
                                                                                                                      ? 19.5
                                                                                                                      : selectedBeginTime == '8:00 PM'
                                                                                                                          ? 20
                                                                                                                          : selectedBeginTime == '8:30 PM'
                                                                                                                              ? 20.5
                                                                                                                              : selectedBeginTime == '9:00 PM'
                                                                                                                                  ? 21
                                                                                                                                  : selectedBeginTime ==
                                                                                                                                          '9:30 PM'
                                                                                                                                      ? 21.5
                                                                                                                                      : null;
      endSlotsList.removeWhere((element) => element.slotIndex <= (selectedBeginTimeIndex + 0.5));
    }
  }

  @override
  void initState() {
    selectedBeginTime = null;
    selectedEndTime = null;
    selectedBeginTimeIndex = null;
    selectedEndTimeIndex = null;
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('booking_history');

    print("selectedBeginTimeIndex ---------------------- $selectedBeginTimeIndex");
    print("selectedEndTimeIndex ------------------------ $selectedEndTimeIndex");
    print("selectedEndTime ----------------------------- $selectedEndTime");
    print("selectedBeginTime --------------------------- $selectedBeginTime");
    print("calendar selected date ---------------------- $selectedDate");
    print("first bookable slot ------------------------- ${endSlotsList.first.slotText}");

    return SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Color(0xff18181A),
              elevation: 0.0,
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
              centerTitle: true,
              title: Text(
                'Book Slot',
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
                  SizedBox(height: 40.h),

                  //date picker
                  Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 32.w),
                    child: SfDateRangePicker(
                      //styles
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: regularStyle,
                        blackoutDateTextStyle: TextStyle(
                          color: Color(0x80bbbbbc),
                          fontSize: 15.sp,
                        ),
                        todayTextStyle: TextStyle(
                          color: Color(0xff8FD974),
                          fontSize: 15.sp,
                        ),
                        disabledDatesTextStyle: TextStyle(
                          color: Color(0x80bbbbbc),
                          fontSize: 15.sp,
                        ),
                      ),
                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        todayTextStyle: TextStyle(
                          color: Color(0xff8FD974),
                          fontSize: 15.sp,
                        ),
                        disabledDatesTextStyle: TextStyle(
                          color: Color(0x80bbbbbc),
                          fontSize: 15.sp,
                        ),
                      ),
                      selectionTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),

                      //settings
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: 'EEE',
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: regularStyle,
                        ),
                        firstDayOfWeek: DateTime.monday,
                        weekendDays: [
                          DateTime.saturday,
                          DateTime.sunday,
                        ],
                      ),

                      //colors
                      selectionColor: Color(0xff8FD974),
                      todayHighlightColor: Color(0xff8FD974),

                      //logic
                      enablePastDates: false,
                      toggleDaySelection: true,
                      showNavigationArrow: true,
                      selectionMode: DateRangePickerSelectionMode.single,

                      //onTap
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                        setState(() {
                          selectedBeginTime = null;
                          selectedDate = args.value.toString();
                          selectedEndTime = null;
                          selectedBeginTimeIndex = null;
                          selectedEndTimeIndex = null;
                        });
                      },
                    ),
                  ),

                  //time pickers
                  StreamBuilder<QuerySnapshot>(
                    stream: collectionRef.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && selectedDate != "null" && selectedDate != null && selectedDate != '') {
                        final entireBookingHistory = snapshot.data.docs.map((e) => BookingHistory.fromJson(e.data())).toList();
                        final filteredBookingHistory = entireBookingHistory
                            .where((element) =>
                                element.dateBooked == selectedDate &&
                                element.sportName == widget.sportBookingInfo.sportName &&
                                element.venueName == widget.venue.venueName)
                            .toList();
                        final slotOneBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 6)).toString())
                            .toList();
                        final slotTwoBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 6, minutes: 30)).toString())
                            .toList();
                        final slotThreeBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 7)).toString())
                            .toList();
                        final slotFourBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 7, minutes: 30)).toString())
                            .toList();
                        final slotFiveBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 8)).toString())
                            .toList();
                        final slotSixBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 8, minutes: 30)).toString())
                            .toList();
                        final slotSevenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 9)).toString())
                            .toList();
                        final slotEightBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 9, minutes: 30)).toString())
                            .toList();
                        final slotNineBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 10)).toString())
                            .toList();
                        final slotTenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 10, minutes: 30)).toString())
                            .toList();
                        final slotElevenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 11)).toString())
                            .toList();
                        final slotTwelveBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 11, minutes: 30)).toString())
                            .toList();
                        final slotThirteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 12)).toString())
                            .toList();
                        final slotFourteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 12, minutes: 30)).toString())
                            .toList();
                        final slotFifteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 13)).toString())
                            .toList();
                        final slotSixteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 13, minutes: 30)).toString())
                            .toList();
                        final slotSeventeenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 14)).toString())
                            .toList();
                        final slotEighteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 14, minutes: 30)).toString())
                            .toList();
                        final slotNineteenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 15)).toString())
                            .toList();
                        final slotTwentyBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 15, minutes: 30)).toString())
                            .toList();
                        final slotTwentyOneBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 16)).toString())
                            .toList();
                        final slotTwentyTwoBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 16, minutes: 30)).toString())
                            .toList();
                        final slotTwentyThreeBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 17)).toString())
                            .toList();
                        final slotTwentyFourBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 17, minutes: 30)).toString())
                            .toList();
                        final slotTwentyFiveBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 18)).toString())
                            .toList();
                        final slotTwentySixBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 18, minutes: 30)).toString())
                            .toList();
                        final slotTwentySevenBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 19)).toString())
                            .toList();
                        final slotTwentyEightBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 19, minutes: 30)).toString())
                            .toList();
                        final slotTwentyNineBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 20)).toString())
                            .toList();
                        final slotThirtyBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 20, minutes: 30)).toString())
                            .toList();
                        final slotThirtyOneBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 21)).toString())
                            .toList();
                        final slotThirtyTwoBooked = filteredBookingHistory
                            .where((element) => element.slotBeginTime == DateTime.parse(selectedDate).add(Duration(hours: 21, minutes: 30)).toString())
                            .toList();

                        bool isSlotDisabled(int index, String slot) {
                          final thisHour = DateTime.now().hour;
                          final timeNow = DateTime.now().minute > 30 ? thisHour + 0.5 : thisHour;
                          final bool timePassed = timeNow >= compareTime[index] && DateTime.parse(selectedDate).day == DateTime.now().day;
                          if (timePassed || (slot == '6:00 AM' && slotOneBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '6:30 AM' && slotTwoBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '7:00 AM' && slotThreeBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '7:30 AM' && slotFourBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '8:00 AM' && slotFiveBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '8:30 AM' && slotSixBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '9:00 AM' && slotSevenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '9:30 AM' && slotEightBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '10:00 AM' && slotNineBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '10:30 AM' && slotTenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '11:00 AM' && slotElevenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '11:30 AM' && slotTwelveBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '12:00 PM' && slotThirteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '12:30 PM' && slotFourteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '1:00 PM' && slotFifteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '1:30 PM' && slotSixteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '2:00 PM' && slotSeventeenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '2:30 PM' && slotEighteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '3:00 PM' && slotNineteenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '3:30 PM' && slotTwentyBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '4:00 PM' && slotTwentyOneBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '4:30 PM' && slotTwentyTwoBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '5:00 PM' && slotTwentyThreeBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '5:30 PM' && slotTwentyFourBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '6:00 PM' && slotTwentyFiveBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '6:30 PM' && slotTwentySixBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '7:00 PM' && slotTwentySevenBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '7:30 PM' && slotTwentyEightBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '8:00 PM' && slotTwentyNineBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '8:30 PM' && slotThirtyBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '9:00 PM' && slotThirtyOneBooked.isNotEmpty)) {
                            return true;
                          }
                          if (timePassed || (slot == '9:30 PM' && slotThirtyTwoBooked.isNotEmpty)) {
                            return true;
                          }
                          return false;
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //from time
                              Text(
                                'FROM',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 110.w,
                                child: DropdownButton(
                                  elevation: 0,
                                  iconSize: 23.r,
                                  menuMaxHeight: 0.5.sh,
                                  iconEnabledColor: Color(0xff8FD974),
                                  isExpanded: true,
                                  value: selectedBeginTime,
                                  hint: Center(
                                    child: Text(
                                      'Begin at...',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  underline: Container(
                                    width: 140.w,
                                    height: 1.h,
                                    color: Color(0xff8FD974),
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    size: 24.r,
                                    color: Color(0xff8FD974),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xffBBBBBC),
                                  ),
                                  onChanged: (val) async {
                                    await validateEndSlots();
                                  },
                                  disabledHint: Center(
                                    child: Text(
                                      'Begin at...',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  items: beginSlotsList.asMap().entries.map((entry) {
                                    final slot = entry?.value;
                                    final index = entry?.key;
                                    final isDisabled = isSlotDisabled(index, slot.slotText);

                                    if (isDisabled) {
                                      return DropdownMenuItem<String>(
                                        value: slot.slotText,
                                        onTap: () {
                                          setState(() {
                                            selectedBeginTime = null;
                                            selectedBeginTimeIndex = null;
                                            selectedEndTimeIndex = null;
                                            selectedEndTime = null;
                                          });
                                        },
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: SizedBox(
                                            width: 110.w,
                                            child: Text(
                                              slot.slotText,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Color(0xff5f5f6e),
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return DropdownMenuItem<String>(
                                        value: slot.slotText,
                                        onTap: () {
                                          setState(() {
                                            selectedBeginTime = slot.slotText;
                                            selectedEndTime = null;
                                            selectedBeginTimeIndex = null;
                                            selectedEndTimeIndex = null;
                                            endSlotsList = [
                                              EndSlotsModel(slotIndex: 7, slotText: '7:00 AM'),
                                              EndSlotsModel(slotIndex: 7.5, slotText: '7:30 AM'),
                                              EndSlotsModel(slotIndex: 8, slotText: '8:00 AM'),
                                              EndSlotsModel(slotIndex: 8.5, slotText: '8:30 AM'),
                                              EndSlotsModel(slotIndex: 9, slotText: '9:00 AM'),
                                              EndSlotsModel(slotIndex: 9.5, slotText: '9:30 AM'),
                                              EndSlotsModel(slotIndex: 10, slotText: '10:00 AM'),
                                              EndSlotsModel(slotIndex: 10.5, slotText: '10:30 AM'),
                                              EndSlotsModel(slotIndex: 11, slotText: '11:00 AM'),
                                              EndSlotsModel(slotIndex: 11.5, slotText: '11:30 AM'),
                                              EndSlotsModel(slotIndex: 12, slotText: '12:00 PM'),
                                              EndSlotsModel(slotIndex: 12.5, slotText: '12:30 PM'),
                                              EndSlotsModel(slotIndex: 13, slotText: '1:00 PM'),
                                              EndSlotsModel(slotIndex: 13.5, slotText: '1:30 PM'),
                                              EndSlotsModel(slotIndex: 14, slotText: '2:00 PM'),
                                              EndSlotsModel(slotIndex: 14.5, slotText: '2:30 PM'),
                                              EndSlotsModel(slotIndex: 15, slotText: '3:00 PM'),
                                              EndSlotsModel(slotIndex: 15.5, slotText: '3:30 PM'),
                                              EndSlotsModel(slotIndex: 16, slotText: '4:00 PM'),
                                              EndSlotsModel(slotIndex: 16.5, slotText: '4:30 PM'),
                                              EndSlotsModel(slotIndex: 17, slotText: '5:00 PM'),
                                              EndSlotsModel(slotIndex: 17.5, slotText: '5:30 PM'),
                                              EndSlotsModel(slotIndex: 18, slotText: '6:00 PM'),
                                              EndSlotsModel(slotIndex: 18.5, slotText: '6:30 PM'),
                                              EndSlotsModel(slotIndex: 19, slotText: '7:00 PM'),
                                              EndSlotsModel(slotIndex: 19.5, slotText: '7:30 PM'),
                                              EndSlotsModel(slotIndex: 20, slotText: '8:00 PM'),
                                              EndSlotsModel(slotIndex: 20.5, slotText: '8:30 PM'),
                                              EndSlotsModel(slotIndex: 21, slotText: '9:00 PM'),
                                              EndSlotsModel(slotIndex: 21.5, slotText: '9:30 PM'),
                                              EndSlotsModel(slotIndex: 22.5, slotText: '10:00 PM'),
                                              EndSlotsModel(slotIndex: 22.5, slotText: '10:30 PM'),
                                            ];
                                          });
                                        },
                                        child: SizedBox(
                                          width: 110.w,
                                          child: Text(
                                            slot.slotText,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ),
                              ),

                              Text(
                                'TO',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                ),
                              ),
                              //end time
                              SizedBox(
                                width: 110.w,
                                child: DropdownButton(
                                  elevation: 0,
                                  iconSize: 23.r,
                                  menuMaxHeight: 0.5.sh,
                                  iconEnabledColor: Color(0xff8FD974),
                                  isExpanded: true,
                                  value: selectedEndTime,
                                  hint: Center(
                                    child: Text(
                                      'End at...',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  underline: Container(
                                    width: 140.w,
                                    height: 1.h,
                                    color: Color(0xff8FD974),
                                  ),
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                    size: 24.r,
                                    color: Color(0xff8FD974),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xffBBBBBC),
                                  ),
                                  onChanged:
                                      selectedBeginTime == null && selectedEndTime == null && selectedBeginTimeIndex == null && selectedEndTimeIndex == null
                                          ? null
                                          : (val) {
                                              setState(() {
                                                selectedEndTime = val;
                                                selectedEndTimeIndex = selectedEndTime == '7:00 AM'
                                                    ? 7
                                                    : selectedEndTime == '7:30 AM'
                                                        ? 7.5
                                                        : selectedEndTime == '8:00 AM'
                                                            ? 8
                                                            : selectedEndTime == '8:30 AM'
                                                                ? 8.5
                                                                : selectedEndTime == '9:00 AM'
                                                                    ? 9
                                                                    : selectedEndTime == '9:30 AM'
                                                                        ? 9.5
                                                                        : selectedEndTime == '10:00 AM'
                                                                            ? 10
                                                                            : selectedEndTime == '10:30 AM'
                                                                                ? 10.5
                                                                                : selectedEndTime == '11:00 AM'
                                                                                    ? 11
                                                                                    : selectedEndTime == '11:30 AM'
                                                                                        ? 11.5
                                                                                        : selectedEndTime == '12:00 PM'
                                                                                            ? 12
                                                                                            : selectedEndTime == '12:30 PM'
                                                                                                ? 12.5
                                                                                                : selectedEndTime == '1:00 PM'
                                                                                                    ? 13
                                                                                                    : selectedEndTime == '1:30 PM'
                                                                                                        ? 13.5
                                                                                                        : selectedEndTime == '2:00 PM'
                                                                                                            ? 14
                                                                                                            : selectedEndTime == '2:30 PM'
                                                                                                                ? 14.5
                                                                                                                : selectedEndTime == '3:00 PM'
                                                                                                                    ? 15
                                                                                                                    : selectedEndTime == '3:30 PM'
                                                                                                                        ? 15.5
                                                                                                                        : selectedEndTime == '4:00 PM'
                                                                                                                            ? 16
                                                                                                                            : selectedEndTime == '4:30 PM'
                                                                                                                                ? 16.5
                                                                                                                                : selectedEndTime == '5:00 PM'
                                                                                                                                    ? 17
                                                                                                                                    : selectedEndTime ==
                                                                                                                                            '5:30 PM'
                                                                                                                                        ? 17.5
                                                                                                                                        : selectedEndTime ==
                                                                                                                                                '6:00 PM'
                                                                                                                                            ? 18
                                                                                                                                            : selectedEndTime ==
                                                                                                                                                    '6:30 PM'
                                                                                                                                                ? 18.5
                                                                                                                                                : selectedEndTime ==
                                                                                                                                                        '7:00 PM'
                                                                                                                                                    ? 19
                                                                                                                                                    : selectedEndTime ==
                                                                                                                                                            '7:30 PM'
                                                                                                                                                        ? 19.5
                                                                                                                                                        : selectedEndTime ==
                                                                                                                                                                '8:00 PM'
                                                                                                                                                            ? 20
                                                                                                                                                            : selectedEndTime == '8:30 PM'
                                                                                                                                                                ? 20.5
                                                                                                                                                                : selectedEndTime == '9:00 PM'
                                                                                                                                                                    ? 21
                                                                                                                                                                    : selectedEndTime == '9:30 PM'
                                                                                                                                                                        ? 21.5
                                                                                                                                                                        : selectedEndTime == '10:00 PM'
                                                                                                                                                                            ? 22
                                                                                                                                                                            : selectedEndTime == '10:30 PM'
                                                                                                                                                                                ? 22.5
                                                                                                                                                                                : null;
                                              });
                                            },
                                  onTap: () {},
                                  disabledHint: Center(
                                    child: Text(
                                      'End at...',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  items: endSlotsList.asMap().entries.map(
                                    (entry) {
                                      return DropdownMenuItem<String>(
                                        value: endSlotsList[entry.key].slotText ?? "test",
                                        onTap: () {
                                          setState(() {
                                            selectedEndTime = endSlotsList[entry.key].slotText;
                                          });
                                        },
                                        child: SizedBox(
                                          width: 110.w,
                                          child: Text(
                                            endSlotsList[entry.key].slotText ?? "test",
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 40.h,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Pick a date to continue',
                              style: labelStyle,
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 40.h),

                  //details & payment btn
                  BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      final sportOffered = state is FootballLoaded
                          ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Football')
                          : state is CricketLoaded
                              ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Cricket')
                              : state is BasketballLoaded
                                  ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Basketball')
                                  : state is HandballLoaded
                                      ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Handball')
                                      : state is TennisLoaded
                                          ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Tennis')
                                          : state is TableTennisLoaded
                                              ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Table Tennis')
                                              : state is SwimmingLoaded
                                                  ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Swimming')
                                                  : state is RugbyLoaded
                                                      ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Rugby')
                                                      : state is BadmintonLoaded
                                                          ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Badminton')
                                                          : state is VolleyballLoaded
                                                              ? widget.venue.sportsOffered?.singleWhere((element) => element.sportName == 'Volleyball')
                                                              : null;

                      return BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, profileState) {
                          if (profileState is EditProfileLoadSuccess) {
                            final bool isMember = profileState.userProfile.clubA == widget.venue.venueName ||
                                profileState.userProfile.clubB == widget.venue.venueName ||
                                profileState.userProfile.clubC == widget.venue.venueName;

                            //handle price
                            String priceToDisplay = '';
                            if (isMember == true) {
                              if (sportOffered.memberRatesPerHr != 0) {
                                if (selectedEndTimeIndex != null && selectedBeginTimeIndex != null) {
                                  final hoursBooked = selectedEndTimeIndex - selectedBeginTimeIndex;
                                  slotDuration = hoursBooked;

                                  priceToDisplay = (sportOffered.memberRatesPerHr * hoursBooked).toString();
                                }
                              } else {
                                if (selectedEndTimeIndex != null && selectedBeginTimeIndex != null) {
                                  final hoursBooked = selectedEndTimeIndex - selectedBeginTimeIndex;
                                  slotDuration = hoursBooked;
                                  priceToDisplay = (sportOffered.memberRatesPerHr * hoursBooked).toString();
                                }
                                priceToDisplay = 'Free';
                              }
                            } else {
                              if (selectedEndTimeIndex != null && selectedBeginTimeIndex != null) {
                                final hoursBooked = selectedEndTimeIndex - selectedBeginTimeIndex;
                                slotDuration = hoursBooked;
                                priceToDisplay = (sportOffered.ratesPerHr * hoursBooked).toString();
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //sports and price
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        //sport
                                        ImageIcon(
                                          AssetImage(
                                            sportOffered.sportName == "Football"
                                                ? 'assets/icons/football_icon.png'
                                                : sportOffered.sportName == 'Table Tennis'
                                                    ? 'assets/icons/table_tennis_icon.png'
                                                    : sportOffered.sportName == "Badminton"
                                                        ? 'assets/icons/badminton_icon.png'
                                                        : sportOffered.sportName == 'Volleyball'
                                                            ? 'assets/icons/volleyball_icon.png'
                                                            : sportOffered.sportName == "Handball"
                                                                ? 'assets/icons/handball_icon.png'
                                                                : sportOffered.sportName == 'Swimming'
                                                                    ? 'assets/icons/swimming_icon.png'
                                                                    : sportOffered.sportName == 'Tennis'
                                                                        ? 'assets/icons/tennis_icon.png'
                                                                        : sportOffered.sportName == 'Rugby'
                                                                            ? 'assets/icons/rugby_icon.png'
                                                                            : sportOffered.sportName == 'Cricket'
                                                                                ? 'assets/icons/cricket_icon.png'
                                                                                : sportOffered.sportName == "Basketball"
                                                                                    ? 'assets/icons/basketball_icon.png'
                                                                                    : '',
                                          ),
                                          size: 26.w,
                                          color: Color(0xff8FD974),
                                        ),

                                        SizedBox(width: 10.w),
                                        //price
                                        Text(
                                          priceToDisplay != 'Free' ? priceToDisplay + ' KES Total' : "Free",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20.h),

                                    //venue
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.venue.venueName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color(0xffBBBBBC),
                                          ),
                                        ),

                                        SizedBox(width: 10.w),
                                        //date
                                        Text(
                                          selectedDate != "null" && selectedDate != '' && selectedDate != null
                                              ? '${DateFormat.MMMMEEEEd().format(DateTime.parse(selectedDate))}'
                                              : "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color(0xffBBBBBC),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20.h),

                                //lipa na mpesa
                                isMember && sportOffered.memberRatesPerHr == 0
                                    ? SizedBox(height: 30.h)
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 32.w, right: 32.w),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Enter M-PESA Number',
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.h),

                                          //txtbox
                                          Padding(
                                            padding: EdgeInsets.only(left: 32.w, right: 32.w),
                                            child: Container(
                                              child: Padding(
                                                padding: MediaQuery.of(context).viewInsets,
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  enabled: isBooked ? false : true,
                                                  controller: phoneNumber,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: '7XXXXXXXX',
                                                    alignLabelWithHint: true,
                                                    isDense: true,
                                                    enabled: true,
                                                    fillColor: Color(0xff31323B),
                                                    filled: true,
                                                    hintStyle: labelStyle,
                                                    labelStyle: labelStyle,
                                                    prefixIcon: Container(
                                                      width: 24.w,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff31323B),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(8.r),
                                                          topLeft: Radius.circular(8.r),
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(bottom: 2.h),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        '+254',
                                                        style: labelStyle.copyWith(
                                                          color: Color(0xff9BEB81),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        style: BorderStyle.none,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        style: BorderStyle.none,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        style: BorderStyle.none,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                    disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        style: BorderStyle.none,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                //pay btn
                                isMember && sportOffered.memberRatesPerHr == 0 ? SizedBox.shrink() : SizedBox(height: 40.h),

                                MaterialButton(
                                  height: 40.h,
                                  minWidth: 88.w,
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
                                  child: isCheckingAvailability == false
                                      ? isMember == true && sportOffered.memberRatesPerHr == 0
                                          ? Text(
                                              'Book',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.sp,
                                              ),
                                            )
                                          : Text(
                                              'Pay',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.sp,
                                              ),
                                            )
                                      : Container(
                                          width: 24.h,
                                          height: 24.h,
                                          child: SpinKitRipple(
                                            color: Colors.black,
                                          ),
                                        ),
                                  onPressed: () async {
                                    var connectivityResult = await (Connectivity().checkConnectivity());

                                    //unfocus field
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    //set loading
                                    setState(() {
                                      isCheckingAvailability = true;
                                    });

                                    if (connectivityResult != ConnectivityResult.none) {
                                      if (selectedDate.isNotEmpty &&
                                          selectedDate != "null" &&
                                          selectedDate != '' &&
                                          selectedBeginTime != null &&
                                          selectedEndTime != null &&
                                          isMember == true &&
                                          sportOffered.memberRatesPerHr == 0) {
                                        updateBookingHistory();
                                      } else if (selectedDate.isNotEmpty &&
                                          selectedDate != "null" &&
                                          selectedDate != '' &&
                                          selectedBeginTime != null &&
                                          selectedEndTime != null &&
                                          phoneNumber.text.length == 9 &&
                                          phoneNumber.text.startsWith('7')) {
                                        //push stk
                                        await startTransaction(amount: 1, phone: "254" + phoneNumber.text);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (BuildContext context) {
                                            return PaymentScreen(
                                              selectedDate: selectedDate,
                                              pricePaid: priceToDisplay,
                                              venue: widget.venue,
                                              slotDuration: slotDuration,
                                              selectedBeginTime: selectedBeginTime,
                                              selectedEndTime: selectedEndTime,
                                              sportBookingInfo: widget.sportBookingInfo,
                                              checkoutId: checkoutId,
                                            );
                                          }),
                                        );
                                        setState(() {
                                          isCheckingAvailability = false;
                                        });
                                      } else {
                                        showCustomSnackbar('Error booking slot. Please input all the fields correctly', _scaffoldKey);
                                        setState(() {
                                          isCheckingAvailability = false;
                                        });
                                      }
                                    } else {
                                      showCustomSnackbar('Please connect to the internet to continue with your booking.', _scaffoldKey);
                                      setState(() {
                                        isCheckingAvailability = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
