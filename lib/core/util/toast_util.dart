import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Hanya dipakai di showSnackBarPoint
import 'package:foriyana_app/core/constant/constant.dart'; // Untuk assets/icons
import 'package:flutter/services.dart'; // Untuk rootBundle jika butuh load asset SVG sebagai bytes

class ToastUtil {
  static void showToast(String title, String message,
      [ToastStatus? ts, int? duration]) {
    final ToastColor color = getColorbyStatus(ts);

    Fluttertoast.showToast(
      msg: "$title\n$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: (duration ?? 2),
      backgroundColor: color.bgcolor ?? Colors.black,
      textColor: color.textcolor ?? Colors.white,
      fontSize: 14.0,
    );
  }

  static void showToastError(String title, String message) {
    showToast(title, message, ToastStatus.error, 2);
  }

  static void showToastPoint(int? point, [int? duration]) async {
    // NOTE: fluttertoast tidak support widget (SVG), hanya string. Jadi kita tampilkan teks + emoji
    Fluttertoast.showToast(
      msg:
          "🎯 +${point ?? 0} poin!\nYuk terus berinteraksi untuk mendapatkan poin",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: (duration ?? 4),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 14.0,
    );
  }

  static ToastColor getColorbyStatus(ToastStatus? ts) {
    switch (ts) {
      case ToastStatus.success:
        return ToastColor(bgcolor: Colors.green, textcolor: Colors.white);
      case ToastStatus.error:
        return ToastColor(bgcolor: Colors.red, textcolor: Colors.white);
      case ToastStatus.warning:
        return ToastColor(bgcolor: Colors.orange, textcolor: Colors.white);
      case ToastStatus.info:
        return ToastColor(bgcolor: Colors.blue, textcolor: Colors.white);
      default:
        return ToastColor(bgcolor: null, textcolor: Colors.black);
    }
  }
}

enum ToastStatus { success, error, warning, info }

class ToastColor {
  Color? bgcolor;
  Color? textcolor;

  ToastColor({this.bgcolor, this.textcolor});
}
