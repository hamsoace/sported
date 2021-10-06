import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/constants/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickDate extends StatefulWidget {
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  String _selectedDate;

  @override
  void initState() {
    _selectedDate = '';
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(
      () {
        _selectedDate = args.value.toString();
        print(_selectedDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('second data | $_selectedDate');

    return Padding(
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
        onSelectionChanged: _onSelectionChanged,
      ),
    );
  }
}
