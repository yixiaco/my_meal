import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
      ),
      builder: (context, child) {
        return TTheme(
          data: TThemeData.formBrightness(Theme.of(context).brightness),
          child: child!,
        );
      },
      initialRoute: RouteQuery.root,
      routes: {},
      onGenerateRoute: onGenerateRoute,
    );
  }
}
