import 'package:my_meal/database/support.dart';
import 'package:my_meal/model/cookbook.dart';

/// 菜谱 DAO
final cookbookDaoSupport = DaoSupport(DaoOpt<Cookbook>(
  idName: 'cookbook_id',
  tableName: 'cookbook',
  setId: (t, id) => t.cookbookId = id,
  getId: (t) => t.cookbookId,
  toMap: (t) => t.toJson(),
  fromMap: (Map<String, Object?> map) => Cookbook.fromJson(map),
));
