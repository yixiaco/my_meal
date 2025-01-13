import 'package:flutter/material.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/var.dart';

/// 显示自定义对话框
Future<T?> showCustomDialog<T>({required BuildContext context, String? title, String? content, List<Widget>? actions}) {
  return showDialog<T>(
    context: context,
    builder: (context) => _buildAlertDialog(context, title: title, content: content, actions: actions),
  );
}

/// 显示询问对话框
Future<T?> showAskDialog<T>({required BuildContext context, String? content}) {
  var theme = TTheme.of(context);
  var colorScheme = theme.colorScheme;
  return showCustomDialog(context: context, title: '提示',content: content, actions: [
    FilledButton(
      onPressed: () {
        Navigator.pop(context, false);
      },
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.bgColorSecondaryContainer,
        overlayColor: colorScheme.bgColorSecondaryContainerActive,
        visualDensity: VisualDensity.compact,
      ),
      child: Text('取消', style: TextStyle(color: colorScheme.textColorPrimary)),
    ),
    FilledButton(
      onPressed: () {
        Navigator.pop(context, true);
      },
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.brandColor,
        overlayColor: colorScheme.brandColorActive,
        visualDensity: VisualDensity.compact,
      ),
      child: Text('确定'),
    ),
  ]);
}

Widget _buildAlertDialog(BuildContext context, {String? title, String? content, List<Widget>? actions}) {
  var theme = TTheme.of(context);
  var colorScheme = theme.colorScheme;
  return AlertDialog(
    title: title != null ? Text(title) : null,
    backgroundColor: colorScheme.bgColorContainer,
    content: content != null ? Text(content) : null,
    actions: actions,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ThemeVar.borderRadiusLarge))),
  );
}
