import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error }

class ToastUtil {
  static void showToast(BuildContext context, ToastType type, String message) {
    switch (type) {
      case ToastType.success:
         CherryToast.success(
        toastDuration: Duration(milliseconds: 2500),
        height: 70,
        toastPosition: Position.top,
        shadowColor: Colors.white,
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        backgroundColor: Colors.green.withAlpha(40),
        description: Text(
          message,
          style: const TextStyle(color: Colors.green),
        ),
        title: const Text(
          "Successful",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ).show(context);
        break;
      case ToastType.error:
        CherryToast.error(
        toastDuration: Duration(milliseconds: 2500),
        height: 70,
        toastPosition: Position.top,
        shadowColor: Colors.white,
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        backgroundColor: Colors.red.withAlpha(40),
        description: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
        title: const Text(
          "Fail",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ).show(context);
        break;
    }
  }
}