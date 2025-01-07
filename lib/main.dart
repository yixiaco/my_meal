import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/theme/theme.dart';

import 'theme/theme_data.dart';

void main() {
  init();

  runApp(ProviderScope(child: const MyApp()));
}

void init() {
  // 初始化之前如果访问二进制文件，需要先初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 解锁刷新率
  GestureBinding.instance.resamplingEnabled = true;

  // 日志记录
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Logger.root.info(PlatformDispatcher.instance.locale);
    return MaterialApp(
      title: '我的饭',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
      ),
      builder: (context, child) {
        Logger.root.info(Theme.of(context).brightness);
        return TTheme(
          data: TThemeData.formBrightness(Theme.of(context).brightness),
          child: child!,
        );
      },
      // 支持中文
      locale: PlatformDispatcher.instance.locale,
      supportedLocales: [
        const Locale('zh', 'CN'),
      ],
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
      ],
      initialRoute: RouteQuery.root,
      routes: {},
      onGenerateRoute: onGenerateRoute,
    );
  }
}
