import 'package:flutter/material.dart';
import 'package:my_meal/theme/color_scheme.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/var.dart';
import 'package:my_meal/util/path_util.dart';

enum TDividerAlign {
  /// 靠左
  left,

  /// 靠右
  right,

  /// 居中
  center;
}

class TDivider extends StatelessWidget {
  const TDivider({
    super.key,
    this.child,
    this.align = TDividerAlign.center,
    this.dashed = false,
    this.layout = Axis.horizontal,
    this.length,
    this.thickness,
    this.margin,
    this.color,
  });

  /// 文本位置（仅在水平分割线有效）
  final TDividerAlign align;

  /// 子部件（仅在水平分割线有效）
  final Widget? child;

  /// 是否虚线
  final bool dashed;

  /// 分隔线类型有两种：水平和垂直
  final Axis layout;

  /// 线条长度
  /// [layout]为[Axis.horizontal]时这里为宽度
  /// [layout]为[Axis.vertical]时这里为高度
  final double? length;

  /// 线条厚度
  final double? thickness;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 线条颜色
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    var colorScheme = theme.colorScheme;
    var fontSize = theme.fontSize;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var data = MediaQuery.of(context);
        var size = data.size;
        var d = 1 / data.devicePixelRatio;
        var maxWidth = constraints.maxWidth == double.infinity ? size.width : constraints.maxWidth;
        double width;
        double height;
        EdgeInsetsGeometry margin;
        Widget? child;
        if (layout == Axis.horizontal) {
          width = length ?? maxWidth;
          height = thickness ?? d;
          margin = this.margin ?? EdgeInsets.symmetric(vertical: ThemeVar.spacer2);
          if (this.child != null) {
            Widget left;
            Widget right;
            switch (align) {
              case TDividerAlign.left:
                left = buildCustomPaint(width * 0.05, height, colorScheme);
                right = Expanded(child: buildCustomPaint(width, height, colorScheme));
                break;
              case TDividerAlign.right:
                left = Expanded(child: buildCustomPaint(width, height, colorScheme));
                right = buildCustomPaint(width * 0.05, height, colorScheme);
                break;
              case TDividerAlign.center:
                left = Expanded(child: buildCustomPaint(width, height, colorScheme));
                right = Expanded(child: buildCustomPaint(width, height, colorScheme));
                break;
            }
            child = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                left,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: fontSize),
                  child: this.child!,
                ),
                right,
              ],
            );
          }
        } else {
          width = thickness ?? d;
          height = length ?? fontSize * 0.9;
          margin = this.margin ?? EdgeInsets.symmetric(horizontal: ThemeVar.spacer * 1.5);
        }

        return Padding(
          padding: margin,
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: theme.fontFamily,
              color: colorScheme.textColorPrimary,
              fontSize: theme.fontSize,
            ),
            child: child ?? buildCustomPaint(width, height, colorScheme),
          ),
        );
      },
    );
  }

  CustomPaint buildCustomPaint(double width, double height, TColorScheme colorScheme) {
    return CustomPaint(
      size: Size(width, height),
      painter: TDividerCustomPainter(
        color: color ?? colorScheme.borderLevel1Color,
        dashed: dashed,
        direction: layout,
      ),
    );
  }
}

/// 分割线画笔
class TDividerCustomPainter extends CustomPainter {
  const TDividerCustomPainter({
    required this.color,
    required this.dashed,
    required this.direction,
  });

  /// 线条颜色
  final Color color;

  /// 是否是虚线
  final bool dashed;

  /// 方向
  final Axis direction;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false;
    var path = Path();

    if (direction == Axis.vertical) {
      path.lineTo(0, size.height);
      paint.strokeWidth = size.width;
    } else {
      path.lineTo(size.width, 0);
      paint.strokeWidth = size.height;
    }

    if (dashed) {
      path = PathUtil.dashPath(path, 3, 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TDividerCustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TDividerCustomPainter &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          dashed == other.dashed &&
          direction == other.direction;

  @override
  int get hashCode => color.hashCode ^ dashed.hashCode ^ direction.hashCode;
}
