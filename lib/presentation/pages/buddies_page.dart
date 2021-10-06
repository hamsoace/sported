import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/constants/constants.dart';

class BuddiesPage extends StatefulWidget {
  @override
  _BuddiesPageState createState() => _BuddiesPageState();
}

class _BuddiesPageState extends State<BuddiesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Buddies Page Under Construction',
            style: regularStyle.copyWith(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
