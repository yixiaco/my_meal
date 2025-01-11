import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// 防抖
class Debounced {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounced({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
