import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/main.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/var.dart';

/// 消息提示
class ToastHold extends InheritedTheme {
  const ToastHold({
    super.key,
    required this.data,
    required super.child,
  });

  final FToast data;

  /// 初始化
  /// [child] 显示的子组件，不能为空
  factory ToastHold.init(BuildContext ctx, Widget? child) {
    var fToast = FToast();
    return ToastHold(
      data: fToast,
      child: FToastBuilder().call(ctx, child!),
    );
  }

  /// 来自封闭给定上下文的最近主题实例的数据
  static FToast? of(BuildContext context) {
    final ToastHold? theme = context.dependOnInheritedWidgetOfExactType<ToastHold>();
    theme?.data.init(navigatorKey.currentContext!);
    return theme?.data;
  }

  /// 成功提示
  static void success(
    BuildContext context,
    String msg, {
    ToastGravity gravity = ToastGravity.TOP,
    bool close = false,
    Duration toastDuration = const Duration(seconds: 5),
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissible = false,
  }) {
    var themeData = TTheme.of(context);
    show(
      context,
      msg,
      icon: Icon(TIcons.check_circle_filled, color: themeData.colorScheme.successColor),
      close: close,
      gravity: gravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      ignorePointer: ignorePointer,
      isDismissible: isDismissible,
    );
  }

  /// 警告提示
  static void warning(
      BuildContext context,
      String msg, {
        ToastGravity gravity = ToastGravity.TOP,
        bool close = false,
        Duration toastDuration = const Duration(seconds: 5),
        Duration fadeDuration = const Duration(milliseconds: 350),
        bool ignorePointer = false,
        bool isDismissible = false,
      }) {
    var themeData = TTheme.of(context);
    show(
      context,
      msg,
      icon: Icon(TIcons.error_circle_filled, color: themeData.colorScheme.warningColor),
      close: close,
      gravity: gravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      ignorePointer: ignorePointer,
      isDismissible: isDismissible,
    );
  }

  /// 错误提示
  static void error(
      BuildContext context,
      String msg, {
        ToastGravity gravity = ToastGravity.TOP,
        bool close = false,
        Duration toastDuration = const Duration(seconds: 5),
        Duration fadeDuration = const Duration(milliseconds: 350),
        bool ignorePointer = false,
        bool isDismissible = false,
      }) {
    var themeData = TTheme.of(context);
    show(
      context,
      msg,
      icon: Icon(TIcons.error_circle_filled, color: themeData.colorScheme.errorColor),
      close: close,
      gravity: gravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      ignorePointer: ignorePointer,
      isDismissible: isDismissible,
    );
  }

  /// 消息提示
  static void info(
      BuildContext context,
      String msg, {
        ToastGravity gravity = ToastGravity.TOP,
        bool close = false,
        Duration toastDuration = const Duration(seconds: 5),
        Duration fadeDuration = const Duration(milliseconds: 350),
        bool ignorePointer = false,
        bool isDismissible = false,
      }) {
    var themeData = TTheme.of(context);
    show(
      context,
      msg,
      icon: Icon(TIcons.info_circle_filled, color: themeData.colorScheme.brandColor),
      close: close,
      gravity: gravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      ignorePointer: ignorePointer,
      isDismissible: isDismissible,
    );
  }

  /// 帮助提示
  static void help(
      BuildContext context,
      String msg, {
        ToastGravity gravity = ToastGravity.TOP,
        bool close = false,
        Duration toastDuration = const Duration(seconds: 5),
        Duration fadeDuration = const Duration(milliseconds: 350),
        bool ignorePointer = false,
        bool isDismissible = false,
      }) {
    var themeData = TTheme.of(context);
    show(
      context,
      msg,
      icon: Icon(TIcons.help_circle_filled, color: themeData.colorScheme.brandColor),
      close: close,
      gravity: gravity,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      ignorePointer: ignorePointer,
      isDismissible: isDismissible,
    );
  }

  /// 显示提示
  static void show(
    BuildContext context,
    String msg, {
    ToastGravity? gravity,
    bool close = false,
    Duration toastDuration = const Duration(seconds: 5),
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissible = false,
    IconData? iconData,
    Icon? icon,
  }) {
    final FToast? fToast = ToastHold.of(context);
    if (fToast != null) {
      var themeData = TTheme.of(context);
      var colorScheme = themeData.colorScheme;
      Widget toast = Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(ThemeVar.borderRadiusMedium),
        color: colorScheme.bgColorContainer,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeVar.size6, vertical: ThemeVar.size5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: ThemeVar.spacer,
            children: [
              if (icon != null || iconData != null)
                IconTheme.merge(
                  data: IconThemeData(
                    color: colorScheme.brandColor,
                    size: themeData.fontData.fontSizeBodyMedium + 6,
                  ),
                  child: icon ?? Icon(iconData),
                ),
              Flexible(child: Text(msg)),
              if (close)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: Icon(TIcons.close, size: themeData.fontData.fontSizeBodyMedium + 6),
                    onTap: () {
                      fToast.removeCustomToast();
                    },
                  ),
                )
            ],
          ),
        ),
      );

      fToast.removeQueuedCustomToasts();

      fToast.showToast(
        child: toast,
        gravity: gravity,
        toastDuration: toastDuration,
        fadeDuration: fadeDuration,
        ignorePointer: ignorePointer,
        isDismissible: isDismissible,
      );
    }
  }

  /// 移除自定义Toast
  static void removeCustomToastOf(BuildContext context) {
    final FToast? fToast = ToastHold.of(context);
    fToast?.removeCustomToast();
  }

  /// 移除所有自定义Toast
  static void removeQueuedCustomToastsOf(BuildContext context) {
    final FToast? fToast = ToastHold.of(context);
    fToast?.removeQueuedCustomToasts();
  }

  @override
  bool updateShouldNotify(ToastHold oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ToastHold(data: data, child: child);
  }
}
