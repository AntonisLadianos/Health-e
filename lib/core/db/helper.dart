import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

alertDialogerror(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red.shade500,
  );
}

alertDialogsuccess(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green.shade500,
  );
}

bool validateEmail(String email) {
  // Regular expression to validate email format
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );
  return emailRegExp.hasMatch(email);
}
