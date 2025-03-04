import 'package:flutter/widgets.dart';

/// 在 appBar 中使用的按钮。
class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Icon(icon),
        ),
      ),
    );
  }
}
