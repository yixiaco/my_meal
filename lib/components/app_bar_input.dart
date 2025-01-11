import 'package:flutter/material.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/theme/theme.dart';

class AppBarInput extends StatefulWidget {
  /// 文本字段的控制器。
  final TextEditingController? controller;

  /// 默认值
  final String? defaultValue;

  /// 当文本字段的值更改时调用。
  final ValueChanged<String>? onChanged;

  const AppBarInput({
    super.key,
    this.controller,
    this.defaultValue,
    this.onChanged,
  });

  @override
  State<AppBarInput> createState() => _AppBarInputState();
}

class _AppBarInputState extends State<AppBarInput> {
  TextEditingController? _controller;

  /// 有效文本控制器
  TextEditingController get effectiveController =>
      widget.controller ?? (_controller ??= TextEditingController(text: widget.defaultValue));

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    var colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      clipBehavior: Clip.antiAlias,
      child: TextField(
        controller: effectiveController,
        onChanged: widget.onChanged,
        cursorColor: colorScheme.textColorPrimary,
        cursorErrorColor: colorScheme.textColorPrimary,
        cursorHeight: 16,
        decoration: InputDecoration(
          hintText: '搜索菜谱',
          hintStyle: TextStyle(color: colorScheme.textColorPlaceholder, fontSize: 14, fontWeight: FontWeight.w500),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              TIcons.search,
              size: 16,
              color: colorScheme.textColorPlaceholder,
              applyTextScaling: false,
            ),
          ),
          prefixIconConstraints: const BoxConstraints.expand(height: 16, width: 30),
          border: InputBorder.none,
          isDense: true,
          isCollapsed: true,
          fillColor: colorScheme.bgColorSecondaryContainer,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0), // 调整内边距,
        ),
      ),
    );
  }
}
