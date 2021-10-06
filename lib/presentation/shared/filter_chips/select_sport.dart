import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/business_logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:sported_app/data/models/venue/venue_model.dart';

import 'custom_chip.dart';
import 'custom_chip_content.dart';

class SelectSport extends StatefulWidget {
  final Venue venue;

  const SelectSport({Key key, this.venue}) : super(key: key);
  @override
  _SelectSportState createState() => _SelectSportState();
}

class _SelectSportState extends State<SelectSport> {
  // single choice value
  int tag = 0;

  // list of string options
  List<String> options = [
    'assets/icons/football_icon.png',
    'assets/icons/cricket_icon.png',
    'assets/icons/badminton_icon.png',
    'assets/icons/basketball_icon.png',
    'assets/icons/tennis_icon.png',
    'assets/icons/swimming_icon.png',
    'assets/icons/volleyball_icon.png',
    'assets/icons/rugby_icon.png',
    'assets/icons/table_tennis_icon.png',
    'assets/icons/handball_icon.png',
  ];

  @override
  Widget build(BuildContext context) {
    print('first tag | ${tag.toString()}');
    return Container(
      height: 42.h,
      child: ListView(
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CustomChipContent(
            child: ChipsChoice<int>.single(
              value: tag,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
              onChanged: (val) {
                setState(() => tag = val);
                if (val == 0) {
                  BlocProvider.of<FilterBloc>(context).add(LoadFootball());
                }
                if (val == 1) {
                  BlocProvider.of<FilterBloc>(context).add(LoadCricket());
                }
                if (val == 2) {
                  BlocProvider.of<FilterBloc>(context).add(LoadBadminton());
                }
                if (val == 3) {
                  BlocProvider.of<FilterBloc>(context).add(LoadBasketball());
                }
                if (val == 4) {
                  BlocProvider.of<FilterBloc>(context).add(LoadTennis());
                }
                if (val == 5) {
                  BlocProvider.of<FilterBloc>(context).add(LoadSwimming());
                }
                if (val == 6) {
                  BlocProvider.of<FilterBloc>(context).add(LoadVolleyball());
                }
                if (val == 7) {
                  BlocProvider.of<FilterBloc>(context).add(LoadRugby());
                }
                if (val == 8) {
                  BlocProvider.of<FilterBloc>(context).add(LoadTableTennis());
                }
                if (val == 9) {
                  BlocProvider.of<FilterBloc>(context).add(LoadHandball());
                }
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              choiceBuilder: (item) {
                return CustomChip(
                  label: item.label,
                  width: 42.h,
                  height: 42.h,
                  selected: item.selected,
                  onSelect: item.select,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
