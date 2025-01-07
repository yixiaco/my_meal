import 'package:flutter/animation.dart';

/// 主题常量
class ThemeVar {
  const ThemeVar._();

  // Border Radius
  static double borderRadiusSmall = 2; // 圆角-2
  static double borderRadiusDefault = 3; // 圆角-3
  static double borderRadiusMedium = 6; // 圆角-6
  static double borderRadiusLarge = 9; // 圆角-9
  static double borderRadiusExtraLarge = 12; // 圆角-12
  static double borderRadiusRound = 999; // 圆角-999

  // Spacer
  static double spacer = 8;
  static double spacerS = spacer * .5; // 间距-4
  static double spacerM = spacer * .75; // 间距-6
  static double spacerL = spacer * 1.5; // 间距-12
  static double spacer1 = spacer; // 间距-8
  static double spacer2 = spacer * 2; // 间距-16
  static double spacer3 = spacer * 3; // 间距-24
  static double spacer4 = spacer * 4; // 间距-32
  static double spacer5 = spacer * 5; // 间距-大-40
  static double spacer6 = spacer * 6; // 间距-大-48
  static double spacer7 = spacer * 7; // 间距-大-48
  static double spacer8 = spacer * 8; // 间距-大-48
  static double spacer9 = spacer * 9; // 间距-大-48
  static double spacer10 = spacer * 10; // 间距-大-80

  static double lineHeightS = 20;
  static double lineHeightBase = 22;
  static double lineHeightL = 24;
  static double lineHeightXl = 28;
  static double lineHeightXxl = 44;

  // 动画
  static Curve animTimeFnEasing = const Cubic(.38, 0, .24, 1);
  static Curve animTimeFnEaseOut = const Cubic(0, 0, .15, 1);
  static Curve animTimeFnEaseIn = const Cubic(.82, 0, 1, .9);
  static Duration animDurationBase = const Duration(milliseconds: 200);
  static Duration animDurationModerate = const Duration(milliseconds: 240);
  static Duration animDurationSlow = const Duration(milliseconds: 280);
}