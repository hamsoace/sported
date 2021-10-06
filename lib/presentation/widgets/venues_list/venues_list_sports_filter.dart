import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';

class VenuesListSportsFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
