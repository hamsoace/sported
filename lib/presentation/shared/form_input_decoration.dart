import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sported_app/constants/constants.dart';

InputDecoration formInputDecoration({
  String hintText,
  String labelText,
  IconData prefixIcon,
  bool isDense,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    alignLabelWithHint: true,
    isDense: isDense,
    enabled: true,
    fillColor: Color(0xff31323B),
    filled: true,
    hintStyle: hintStyle.copyWith(color: Colors.white),
    labelStyle: labelStyle.copyWith(color: Colors.white),
    prefixIcon: Icon(
      prefixIcon,
      color: Color(0xff8FD974),
      size: 21.r,
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
  );
}
