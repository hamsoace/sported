import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthUnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: 280.h,
            width: 280.h,
            child: Image.asset(
              'assets/icons/sported_logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
