import 'package:flutter/cupertino.dart';
import 'package:my_meal/page/cookbook/cookbook_edit.dart';
import 'package:my_meal/page/cookbook/cookbook_preview.dart';
import 'package:my_meal/page/home.dart';

class RouteQuery {
  RouteQuery._();

  /// 根路由
  static const String root = '/';
  /// 创建菜谱
  static const String cookbookEdit = '/cookbookEdit';
  /// 预览菜谱
  static const String cookbookPreview = '/cookbookPreview';

  static final routes = {
    root: HomePage(),
    cookbookEdit: CookbookEdit(),
    cookbookPreview: CookbookPreview(),
  };
}

//固定写法
Route? onGenerateRoute(RouteSettings settings) {
  Widget? widget;
  // 统一处理
  String name = settings.name!;
  widget = RouteQuery.routes[name];
  if (widget != null) {
    return CupertinoPageRoute(
      // settings参数不能丢，否则popUnit方法会报异常
      settings: settings,
      builder: (context) => widget!,
    );
  }
  return null;
}
