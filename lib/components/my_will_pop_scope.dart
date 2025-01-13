import 'package:flutter/material.dart';

import 'show_dialog.dart';

class MyWillPopScope extends StatelessWidget {
  const MyWillPopScope({super.key, required this.child, this.shouldPop});

  /// 子组件
  final Widget child;

  /// 是否可以返回
  final ValueNotifier<bool>? shouldPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (shouldPop?.value == true) {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
        } else if (!didPop) {
          // 提示未保存
          var $shouldPop = await _showAlertDialog(context);
          if ($shouldPop == true && Navigator.of(context).canPop()) {
            // 确认退出时执行此操作
            Navigator.pop(context);
          }
        }
      },
      child: child,
    );
  }

  Future<bool?> _showAlertDialog(BuildContext context) async {
    return showAskDialog<bool>(
      context: context,
      content: '菜谱未保存，是否退出当前页面',
    );
  }
}
