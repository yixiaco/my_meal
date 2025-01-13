import 'package:flutter/material.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/var.dart';

class MyWillPopScope extends StatelessWidget {
  const MyWillPopScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        // 提示未保存
        var shouldPop = await showDialog<bool>(context: context, builder: (context) => _buildAlertDialog(context));
        if (shouldPop == true && Navigator.of(context).canPop()) {
          // 确认退出时执行此操作
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    var theme = TTheme.of(context);
    var colorScheme = theme.colorScheme;
    return AlertDialog(
      title: Text('提示'),
      backgroundColor: colorScheme.bgColorContainer,
      content: Text('菜谱未保存，是否退出当前页面'),
      actions: <Widget>[
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
      ],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ThemeVar.borderRadiusLarge))),
    );
  }
}
