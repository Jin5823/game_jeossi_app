import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastUtils {
  static void showToast(String message) {
    // 텍스트 길이에 맞춰서 시간 결정
    double multiplier = 0.5;
    double flag = message.length * 0.06 + 0.5;
    // 타임 계산하고
    int timeInSecForIos = (multiplier * flag).round();
    // 중복시 기존꺼 캔슬
    Fluttertoast.cancel();
    // Toast
    Fluttertoast.showToast(
      backgroundColor: Colors.black54,
      msg: message,
      //위치
      gravity: ToastGravity.CENTER,
      // iOS 일경우 타임설정(?)
      timeInSecForIosWeb: timeInSecForIos,
    );
  }
}
