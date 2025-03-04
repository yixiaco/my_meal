import 'package:flutter/material.dart';
import 'package:my_meal/theme/theme.dart';

/// 自定义Tab组件
class CustomTab extends StatelessWidget {
  const CustomTab({
    super.key,
    this.text,
    required this.icon,
    this.color,
    this.onPressed,
  });

  /// 图标
  final IconData icon;

  /// 文本
  final String? text;

  /// 颜色
  final Color? color;

  /// 点击回调
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    return DefaultTextStyle.merge(
      style: TextStyle(fontSize: theme.fontData.fontSizeBodySmall, color: color),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Tab(
            icon: Icon(icon, size: theme.fontData.fontSizeL, color: color),
            text: text,
          ),
        ),
      ),
    );
  }
}
