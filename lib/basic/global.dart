import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/database/db.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Global {
  Global._();

  static late PackageInfo packageInfo;

  static Future<void> init() async {
    // 初始化之前如果访问二进制文件，需要先初始化
    WidgetsFlutterBinding.ensureInitialized();

    packageInfo = await PackageInfo.fromPlatform();

    if (kDebugMode) {
      print(packageInfo);
    }

    // 在桌面平台上，开启重采样。移动端会有滚动跳跃的问题
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 解锁刷新率
      GestureBinding.instance.resamplingEnabled = true;
    }

    // 日志记录
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });

    await Db.init();
  }
}
