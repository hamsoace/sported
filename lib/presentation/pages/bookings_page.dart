import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:sported_app/business_logic/cubits/booking_history_cubit/booking_history_cubit.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:sported_app/data/models/booking/booking_history_model.dart';
import 'package:sported_app/presentation/widgets/bookings/bookings_grid.dart';

class BookingsHistoryPage extends StatelessWidget {
  final BookingHistory bookingHistory;

  const BookingsHistoryPage({Key key, this.bookingHistory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //app bar
        SliverAppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          title: Text(
            'Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              //select sports

              Container(
                height: 42.h,
                child: BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    return ListView(
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.only(left: 16.0.w),
                      scrollDirection: Axis.horizontal,
                      children: [
                        //football
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadFootball());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is FootballLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/football_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/football_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //cricket
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadCricket());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is CricketLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/cricket_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/cricket_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //badminton
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadBadminton());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is BadmintonLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/badminton_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/badminton_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //basketball
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadBasketball());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is BasketballLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/basketball_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/basketball_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //tennis
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadTennis());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is TennisLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/tennis_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/tennis_icon.png'),
                                size: 24.r,
                                color: Color(0xff28282B),
                              ),
                            ),
                          ),
                        ),
                        //swimming
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadSwimming());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is SwimmingLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/swimming_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/swimming_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //volleyballl
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadVolleyball());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is VolleyballLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/volleyball_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/volleyball_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //rugby
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadRugby());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is RugbyLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/rugby_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/rugby_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //table tennis
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadTableTennis());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is TableTennisLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/table_tennis_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(AssetImage('assets/icons/table_tennis_icon.png'), size: 24.r, color: Color(0xff28282B)),
                            ),
                          ),
                        ),
                        //handball
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<FilterBloc>(context).add(LoadHandball());
                            BlocProvider.of<BookingHistoryCubit>(context).loadBookingHistory();
                          },
                          child: Visibility(
                            visible: state is HandballLoaded,
                            //when not selectedd
                            replacement: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff31323B),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/handball_icon.png'),
                                size: 24.r,
                                color: Colors.white,
                              ),
                            ),

                            //when selected
                            child: AnimatedContainer(
                              width: 42.h,
                              height: 42.h,
                              padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                              margin: EdgeInsets.only(right: 10.w),
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff8FD974),
                              ),
                              child: ImageIcon(
                                AssetImage('assets/icons/handball_icon.png'),
                                size: 24.r,
                                color: Color(0xff28282B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              //bookings
              BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
                builder: (context, state) {
                  if (state is BookingHistoryLoadSuccess) {
                    return BlocBuilder<FilterBloc, FilterState>(
                      builder: (context, sportState) {
                        if (sportState is FootballLoaded) {
                          final footballHistory = state.userBookingHistory.where((element) => element.sportName == 'Football').toList();
                          footballHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));
                          return BookingsGrid(userBookingHistory: footballHistory);
                        }
                        if (sportState is CricketLoaded) {
                          final cricketHistory = state.userBookingHistory.where((element) => element.sportName == 'Cricket').toList();
                          cricketHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));
                          return BookingsGrid(userBookingHistory: cricketHistory);
                        }
                        if (sportState is BadmintonLoaded) {
                          final badmintonHistory = state.userBookingHistory.where((element) => element.sportName == 'Badminton').toList();
                          badmintonHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: badmintonHistory);
                        }
                        if (sportState is BasketballLoaded) {
                          final basketballHistory = state.userBookingHistory.where((element) => element.sportName == 'Basketball').toList();
                          basketballHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: basketballHistory);
                        }
                        if (sportState is TennisLoaded) {
                          final tennisLoaded = state.userBookingHistory.where((element) => element.sportName == 'Tennis').toList();
                          tennisLoaded.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: tennisLoaded);
                        }
                        if (sportState is SwimmingLoaded) {
                          final swimmingHistory = state.userBookingHistory.where((element) => element.sportName == 'Swimming').toList();
                          swimmingHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: swimmingHistory);
                        }
                        if (sportState is VolleyballLoaded) {
                          final volleyballLoaded = state.userBookingHistory.where((element) => element.sportName == 'Volleyball').toList();
                          volleyballLoaded.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: volleyballLoaded);
                        }
                        if (sportState is RugbyLoaded) {
                          final rugbyHistory = state.userBookingHistory.where((element) => element.sportName == 'Rugby').toList();
                          rugbyHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: rugbyHistory);
                        }
                        if (sportState is TableTennisLoaded) {
                          final tableTennisHistory = state.userBookingHistory.where((element) => element.sportName == 'Table Tennis').toList();
                          tableTennisHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: tableTennisHistory);
                        }
                        if (sportState is HandballLoaded) {
                          final handballHistory = state.userBookingHistory.where((element) => element.sportName == 'Handball').toList();

                          handballHistory.removeWhere((element) => DateTime.now().isAfter(DateTime.parse(element.dateBooked.toString())));

                          return BookingsGrid(userBookingHistory: handballHistory);
                        } else
                          return Container();
                      },
                    );
                  } else if (state is BookingHistoryLoadInProgress) {
                    return Container(
                      height: 200.h,
                      child: Center(
                        child: SpinKitRipple(
                          color: Color(0xff9BEB81),
                        ),
                      ),
                    );
                  } else if (state is BookingHistoryLoadFailure) {
                    return Container(
                      height: 400.h,
                      child: Center(
                        child: Text(
                          'Couldn\'t load your booking history.',
                          style: regularStyle,
                        ),
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
