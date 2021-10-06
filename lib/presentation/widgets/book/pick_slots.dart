import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickSlots extends StatefulWidget {
  @override
  _PickSlotsState createState() => _PickSlotsState();
}

class _PickSlotsState extends State<PickSlots> {
  int selectedSlot = 0;
  List<String> timeOptions = [
    '0600 hrs',
    '0700 hrs',
    '0800 hrs',
    '0900 hrs',
    '1000 hrs',
    '1100 hrs',
    '1200 hrs',
    '1300 hrs',
    '1400 hrs',
    '1500 hrs',
    '1600 hrs',
    '1700 hrs',
    '1800 hrs',
    '1900 hrs',
    '2000 hrs',
    '2100 hrs',
  ];

  @override
  Widget build(BuildContext context) {
    print('slot no: | $selectedSlot');
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Slots Available',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            //slots
            ChipsChoice<int>.single(
              wrapped: true,
              padding: EdgeInsets.all(0),
              value: selectedSlot,
              spacing: 8.0.w,
              runSpacing: 10.h,
              onChanged: (val) {
                return setState(() => selectedSlot = val);
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: timeOptions,
                value: (int, string) => int,
                label: (int, string) => string,
              ),
              choiceBuilder: (item) {
                return Column(
                  children: [
                    AnimatedContainer(
                      width: 69.h,
                      height: 42.h,
                      duration: Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            color: Color(0xff3E3E3E), style: BorderStyle.solid, width: 0.5.w),
                        borderRadius: BorderRadius.circular(23.r),
                        color: item.selected ? Color(0xff8FD974) : Color(0xff07070A),
                      ),
                      child: InkWell(
                        onTap: () {
                          item.select(!item.selected);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Visibility(
                              visible: item.selected,
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: item.selected ? Colors.black : Color(0xff707070),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: item.selected ? Colors.black : Color(0xff707070),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
