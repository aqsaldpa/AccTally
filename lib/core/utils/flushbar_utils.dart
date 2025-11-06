import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FlushbarUtils {
  Flushbar<dynamic>? _currentFlushbar;

  void showSuccess(String message, {String? title}) {
    _dismissPrevious();
    _currentFlushbar = Flushbar(
      title: title,
      margin: const EdgeInsets.all(16),
      message: message,
      borderRadius: BorderRadius.circular(8.r),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    )..show(Get.context!);
  }

  void showError(String message, {String? title}) {
    _dismissPrevious();
    _currentFlushbar = Flushbar(
      title: title ?? 'Error',
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(8.r),
      margin: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(Icons.error, color: Colors.white),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(Get.context!);
  }

  void showInfo(String message, {String? title}) {
    _dismissPrevious();
    _currentFlushbar = Flushbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      borderRadius: BorderRadius.circular(8.r),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info, color: Colors.white),
      leftBarIndicatorColor: Colors.lightBlue,
    )..show(Get.context!);
  }

  void showWarning(String message, {String? title}) {
    _dismissPrevious();
    _currentFlushbar = Flushbar(
      title: title ?? 'Peringatan',
      message: message,
      backgroundColor: Colors.orange,
      borderRadius: BorderRadius.circular(8.r),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(Icons.warning, color: Colors.white),
      leftBarIndicatorColor: Colors.orangeAccent,
    )..show(Get.context!);
  }

  void showLoading(String message, {String? title}) {
    _dismissPrevious();
    _currentFlushbar = Flushbar(
      title: title,
      message: message,
      backgroundColor: Colors.grey[700]!,
      duration: const Duration(hours: 1),
      borderRadius: BorderRadius.circular(8.r),
      margin: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white),
      ),
      leftBarIndicatorColor: Colors.grey,
    )..show(Get.context!);
  }

  void dismiss() {
    _dismissPrevious();
  }

  void _dismissPrevious() {
    if (_currentFlushbar != null) {
      _currentFlushbar?.dismiss();
      _currentFlushbar = null;
    }
  }
}

final flush = FlushbarUtils();
