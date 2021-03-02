import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

/// 提示信息
/// 显示文本toast，默认时间两秒；
/// 返回一个函数，再次调用函数关闭toast
CancelFunc showToast(String msg) {
  return BotToast.showText(
    text: msg,
    textStyle: TextStyle(
      fontSize: 26,
      color: Colors.white,
    ),
    borderRadius: BorderRadius.circular(8),
    align: Alignment(0, 0.5),
  );
}

/// 警告信息
/// 显示文本toast，默认时间两秒；背景黄色，文字白色，用于警告.
/// 返回一个函数，再次调用函数关闭toast
CancelFunc showToastForWarning(String msg) {
  return BotToast.showText(
    text: msg,
    contentColor: Color(0xFFffc107),
    textStyle: TextStyle(
      fontSize: 26,
      color: Colors.white,
    ),
    borderRadius: BorderRadius.circular(8),
    align: Alignment(0, 0.5),
  );
}

/// 错误信息
/// 显示文本toast，背景是红色，文字白色。用于报错
/// 时间5秒，可手动关闭
CancelFunc showToastForException(String msg) {
  return BotToast.showText(
    text: msg,
    contentColor: Colors.red,
    textStyle: TextStyle(
      fontSize: 26,
      color: Colors.white,
    ),
    duration: Duration(
      seconds: 5,
    ),
    clickClose: true,
  );
}

/// 显示widget toast
CancelFunc showWidget({@required Widget child}) {
  return BotToast.showAnimationWidget(
    animationDuration: Duration(milliseconds: 0),
    backgroundColor: Colors.black.withAlpha(100),
    toastBuilder: (CancelFunc cancelFunc) {
      return child;
    },
  );
}
