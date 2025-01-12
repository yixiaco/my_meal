import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RefreshNotifier extends ChangeNotifier {
  RefreshNotifier();

  void refresh() {
    notifyListeners();
  }
}

final refreshProvider = ChangeNotifierProvider<RefreshNotifier>((ref) => RefreshNotifier());