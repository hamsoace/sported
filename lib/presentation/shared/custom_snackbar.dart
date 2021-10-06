import 'package:flutter/material.dart';

showCustomSnackbar(String message, GlobalKey<ScaffoldState> scaffoldKey) {
  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color(0xffd0e9c8),
    duration: Duration(milliseconds: 2000),
    content: Text(
      "$message",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
  // ignore: deprecated_member_use
  scaffoldKey.currentState.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  scaffoldKey.currentState.showSnackBar(snackbar);
}
