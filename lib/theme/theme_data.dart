import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:my_meal/basic/basic.dart';

import 'color_scheme.dart';
import 'font_data.dart';

/// 颜色主题数据
class TThemeData with Diagnosticable {
  factory TThemeData({
    required Brightness brightness,
    TColorScheme? colorScheme,
    TComponentSize? size,
    TextDirection? textDirection,
    String? fontFamily,
    TFontData? fontData,
  }) {
    var family = fontFamily ?? 'Microsoft YaHei';
    return TThemeData.raw(
      brightness: brightness,
      colorScheme: colorScheme ?? (brightness == Brightness.light ? TColorScheme.light : TColorScheme.dark),
      size: size ?? TComponentSize.medium,
      textDirection: textDirection ?? TextDirection.ltr,
      fontFamily: family,
      fontData: fontData ?? TFontData.defaultFontData(family),
    );
  }

  TThemeData.raw({
    required this.brightness,
    required this.colorScheme,
    required this.size,
    required this.textDirection,
    required this.fontFamily,
    required this.fontData,
  });

  /// 描述主题或调色板的对比度。
  final Brightness brightness;

  /// 配色方案
  final TColorScheme colorScheme;

  /// 组件尺寸,默认medium。可选项：small/medium/large
  final TComponentSize size;

  /// 文本方向
  final TextDirection textDirection;

  /// 字体
  final String fontFamily;

  /// 字体相关
  final TFontData fontData;

  /// 基础/下层 投影 hover 使用的组件包括：表格 /
  List<BoxShadow> get shadow1 => colorScheme.shadow1;

  /// 中层投影 下拉 使用的组件包括：下拉菜单 / 气泡确认框 / 选择器 /
  List<BoxShadow> get shadow2 => colorScheme.shadow2;

  /// 上层投影（警示/弹窗）使用的组件包括：全局提示 / 消息通知
  List<BoxShadow> get shadow3 => colorScheme.shadow3;

  // 内投影 用于弹窗类组件（气泡确认框 / 全局提示 / 消息通知）的内描边
  BoxShadow get shadowInsetTop => colorScheme.shadowInsetTop;

  BoxShadow get shadowInsetRight => colorScheme.shadowInsetRight;

  BoxShadow get shadowInsetBottom => colorScheme.shadowInsetBottom;

  BoxShadow get shadowInsetLeft => colorScheme.shadowInsetLeft;

  List<BoxShadow> get shadowInset => [shadowInsetTop, shadowInsetRight, shadowInsetBottom, shadowInsetLeft];

  // 融合阴影
  List<BoxShadow> get shadow2Inset => [...shadow2, ...shadowInset];

  List<BoxShadow> get shadow3Inset => [...shadow3, ...shadowInset];

  /// 根据主题颜色创建主题
  factory TThemeData.formBrightness(Brightness brightness) => brightness == Brightness.light ? TThemeData.light() : TThemeData.dark();

  /// 默认的亮色样式
  factory TThemeData.light() => TThemeData(brightness: Brightness.light);

  /// 默认的暗黑样式
  factory TThemeData.dark() => TThemeData(brightness: Brightness.dark);

  /// 根据平台自动选择主题
  ///
  /// [context] 构建上下文
  factory TThemeData.auto(BuildContext context) {
    return TThemeData.formBrightness(MediaQuery.platformBrightnessOf(context));
  }

  /// 通用字体大小
  double get fontSize => size.lazySizeOf(
        small: () => fontData.fontSizeS,
        medium: () => fontData.fontSizeBase,
        large: () => fontData.fontSizeL,
      );

  /// 是否是亮色主题
  bool get isLight => brightness == Brightness.light;

  TThemeData copyWith({
    Brightness? brightness,
    TColorScheme? colorScheme,
    TComponentSize? size,
    TextDirection? textDirection,
    String? fontFamily,
  }) {
    return TThemeData(
      brightness: brightness ?? this.brightness,
      colorScheme: colorScheme ?? this.colorScheme,
      size: size ?? this.size,
      textDirection: textDirection ?? this.textDirection,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TThemeData &&
          runtimeType == other.runtimeType &&
          brightness == other.brightness &&
          colorScheme == other.colorScheme &&
          size == other.size &&
          textDirection == other.textDirection &&
          fontFamily == other.fontFamily;

  @override
  int get hashCode =>
      brightness.hashCode ^
      colorScheme.hashCode ^
      size.hashCode ^
      textDirection.hashCode ^
      fontFamily.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: null));
    properties.add(DiagnosticsProperty<TColorScheme>('colorScheme', colorScheme, defaultValue: null));
    properties.add(DiagnosticsProperty<TComponentSize>('size', size, defaultValue: null));
    properties.add(DiagnosticsProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('fontFamily', fontFamily, defaultValue: null));
    properties.add(DiagnosticsProperty<TFontData>('fontData', fontData, defaultValue: null));
  }
}
