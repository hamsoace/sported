import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';

class BookScreenSportsFilter extends StatelessWidget {
  // final List<SportData> selectedVenueSportsAvailable;
  // final String selectedVenueId;
  //
  // const BookScreenSportsFilter({
  //   Key key,
  //   @required this.selectedVenueSportsAvailable,
  //   @required this.selectedVenueId,
  // }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          return ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: 1,
            padding: EdgeInsets.only(left: 16.0.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final sportName = 'selectedVenueSportsAvailable[index].sportName';

              //football
              return GestureDetector(
                onTap: () {
                  sportName == 'Football'
                      ? BlocProvider.of<FilterBloc>(context).add(LoadFootball())
                      : sportName == 'Cricket'
                          ? BlocProvider.of<FilterBloc>(context).add(LoadCricket())
                          : sportName == 'Badminton'
                              ? BlocProvider.of<FilterBloc>(context).add(LoadBadminton())
                              : sportName == 'Basketball'
                                  ? BlocProvider.of<FilterBloc>(context).add(LoadBasketball())
                                  : sportName == 'Tennis'
                                      ? BlocProvider.of<FilterBloc>(context).add(LoadTennis())
                                      : sportName == 'Swimming'
                                          ? BlocProvider.of<FilterBloc>(context).add(LoadSwimming())
                                          : sportName == 'Volleyball'
                                              ? BlocProvider.of<FilterBloc>(context).add(LoadVolleyball())
                                              : sportName == 'Rugby'
                                                  ? BlocProvider.of<FilterBloc>(context).add(LoadRugby())
                                                  : sportName == 'Table Tennis'
                                                      ? BlocProvider.of<FilterBloc>(context).add(LoadTableTennis())
                                                      : sportName == 'Handball'
                                                          ? BlocProvider.of<FilterBloc>(context).add(LoadHandball())
                                                          // ignore: unnecessary_statements
                                                          : null;
                },
                child: Visibility(
                  visible: sportName == 'Football'
                      ? state is FootballLoaded
                      : sportName == 'Cricket'
                          ? state is CricketLoaded
                          : sportName == 'Badminton'
                              ? state is BadmintonLoaded
                              : sportName == 'Basketball'
                                  ? state is BasketballLoaded
                                  : sportName == 'Tennis'
                                      ? state is TennisLoaded
                                      : sportName == 'Swimming'
                                          ? state is SwimmingLoaded
                                          : sportName == 'Volleyball'
                                              ? state is VolleyballLoaded
                                              : sportName == 'Rugby'
                                                  ? state is RugbyLoaded
                                                  : sportName == 'Table Tennis'
                                                      ? state is TableTennisLoaded
                                                      : sportName == 'Handball'
                                                          ? state is HandballLoaded
                                                          : false,
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
                      size: 24.r,
                      color: Color(0xff28282B),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
