import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/basic/global.dart';

import 'components/toast.dart';
import 'model/cookbook.dart';
import 'theme/theme_data.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await Global.init();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Logger.root.info(PlatformDispatcher.instance.locale);
    return TTheme(
      data: TThemeData.auto(context),
      child: Builder(builder: (context) {
        var colorScheme = TTheme.of(context).colorScheme;
        return MaterialApp(
          title: '我的饭',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: colorScheme.bgColorContainer,
              surfaceTintColor: colorScheme.bgColorContainer,
              titleSpacing: 6,
            ),
            scaffoldBackgroundColor: colorScheme.bgColorContainer,
            brightness: Brightness.light,
            useMaterial3: true,
            fontFamily: 'Microsoft YaHei',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: colorScheme.brandColor),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            fontFamily: 'Microsoft YaHei',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: colorScheme.brandColor, brightness: Brightness.dark),
          ),
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
          navigatorKey: navigatorKey,
          builder: ToastHold.init,
        );
      }),
    );
  }
}
