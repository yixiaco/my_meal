import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';

/// dao操作
class DaoOpt<T> {
  /// 主键名称
  final String idName;

  /// 表名
  final String tableName;

  /// 设置主键
  final Function(T t, dynamic id) setId;

  /// 获取主键值
  final dynamic Function(T t) getId;

  /// 转换为map
  final Map<String, dynamic> Function(T t) toMap;

  /// 转换为对象
  final T Function(Map<String, Object?> map) fromMap;

  const DaoOpt({
    required this.idName,
    required this.tableName,
    required this.setId,
    required this.getId,
    required this.toMap,
    required this.fromMap,
  });
}

/// 支持数据库操作
///
/// example:
/// ```dart
/// final demoDaoSupport = DaoSupport(DaoOpt<Demo>(
///   idName: 'demo_id',
///   tableName: 'demo',
///   setId: (t, id) => t.demoId = id,
///   getId: (t) => t.demoId,
///   toMap: (t) => t.toJson(),
///   fromMap: (Map<String, Object?> map) => Demo.fromJson(map),
/// ));
/// ```
class DaoSupport<T> {
  /// dao对象操作
  final DaoOpt<T> daoOpt;

  DaoSupport(this.daoOpt);

  DatabaseExecutor get executor => _transaction ?? Db.db;

  Transaction? _transaction;

  /// 批量事务注入
  ///
  /// example:
  /// ```dart
  /// await DaoSupport.transaction([demoDaoSupport1, demoDaoSupport2], () {
  ///   demoDaoSupport1.insert(Demo1());
  ///   demoDaoSupport2.insert(Demo2());
  /// });
  /// ```
  static Future<T> batchTransaction<T>(List<DaoSupport> s, Future<T> Function() tx) {
    return Db.db.transaction((txn) {
      try {
        for (var element in s) {
          element._transaction = txn;
        }
        return tx();
      } finally {
        for (var element in s) {
          element._transaction = null;
        }
      }
    });
  }

  /// 执行事务
  Future<S> transaction<S>(Future<S> Function() tx) {
    return Db.db.transaction((txn) {
      try {
        _transaction = txn;
        return tx();
      } finally {
        _transaction = null;
      }
    });
  }

  /// 查询一个字段
  Future<dynamic> queryField(String sql, [List<dynamic>? arguments]) async {
    List<Map<String, Object?>> list = await executor.rawQuery(sql, arguments);
    if (list.isNotEmpty) {
      return list[0].values.first;
    }
    return null;
  }

  /// 查询一行
  Future<T?> queryRawForMap(String sql, [List<dynamic>? arguments]) async {
    List<Map<String, Object?>> list = await executor.rawQuery(sql, arguments);
    if (list.isNotEmpty) {
      return daoOpt.fromMap(list[0]);
    }
    return null;
  }

  /// 查询一行
  Future<T?> queryForMap({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    List<Map<String, Object?>> list = await executor.query(
      daoOpt.tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );
    if (list.isNotEmpty) {
      return daoOpt.fromMap(list[0]);
    }
    return null;
  }

  /// 主键查询
  Future<T?> findById(dynamic id) async {
    List<Map<String, Object?>> list = await executor.query(
      daoOpt.tableName,
      where: '${daoOpt.idName} = ?',
      whereArgs: [id],
    );
    if (list.isNotEmpty) {
      return daoOpt.fromMap(list[0]);
    }
    return null;
  }

  /// 多主键查询
  Future<List<T>> findByIds(List<dynamic> ids) async {
    List<Map<String, Object?>> list = await executor.query(
      daoOpt.tableName,
      where: '${daoOpt.idName} in(${DaoSupport.sqlIn(ids.length)})',
      whereArgs: ids,
    );
    if (list.isNotEmpty) {
      return list.map((e) => daoOpt.fromMap(e)).toList();
    }
    return List.empty();
  }

  /// 删除数据库中的行的便捷方法。
  /// Delete from （删除自） table
  /// where 是更新时要应用的可选 WHERE 子句。传递 null 将删除所有行。
  /// 您可以在 where 子句中包含 ？s，这将被 whereArgs
  /// 返回受影响的行数。
  Future<int> deleteById(dynamic id) async {
    return executor.delete(
      daoOpt.tableName,
      where: '${daoOpt.idName} = ?',
      whereArgs: [id],
    );
  }

  /// 批量删除
  Future<List<Object?>> batchDeleteById(List<dynamic> ids) async {
    Batch batch = executor.batch();
    for (var id in ids) {
      batch.delete(
        daoOpt.tableName,
        where: '${daoOpt.idName} = ?',
        whereArgs: [id],
      );
    }
    return batch.commit();
  }

  /// 插入, 返回主键值
  Future<int> insert(T t) async {
    var id = await executor.insert(daoOpt.tableName, daoOpt.toMap(t));
    daoOpt.setId(t, id);
    return id;
  }

  /// 批量插入
  Future<List<Object?>> batchInsert(List<T> objects) async {
    Batch batch = executor.batch();
    for (var value in objects) {
      batch.insert(daoOpt.tableName, daoOpt.toMap(value));
    }
    List ids = await batch.commit();
    for (int i = 0; i < objects.length; i++) {
      daoOpt.setId(objects[i], ids[i]);
    }
    return ids;
  }

  /// 更新
  /// 如果id为null，则更新所有行。
  /// 否则更新id值相同的行。
  Future<int> update(T t) async {
    Map<String, dynamic> map = daoOpt.toMap(t);
    var id = daoOpt.getId(t);
    assert(id != null, 'id cannot be null');
    if (id != null) {
      return executor.update(
        daoOpt.tableName,
        map,
        where: '${daoOpt.idName} = ?',
        whereArgs: [id],
      );
    } else {
      return executor.update(
        daoOpt.tableName,
        map,
      );
    }
  }

  /// 批量更新
  Future<List<Object?>> batchUpdate(List<T> objects) async {
    Batch batch = executor.batch();
    for (var value in objects) {
      Map<String, dynamic> map = daoOpt.toMap(value);
      var id = daoOpt.getId(value);
      assert(id != null, 'id cannot be null');
      batch.update(
        daoOpt.tableName,
        map,
        where: '${daoOpt.idName} = ?',
        whereArgs: [id],
      );
    }
    return batch.commit();
  }

  /// 保存
  /// 如果id为null，则插入，否则更新
  /// 插入时返回id值
  /// 更新返回受影响的行数
  Future<int> saveOrUpdate(T t) async {
    var id = daoOpt.getId(t);
    if (id != null) {
      return update(t);
    } else {
      return insert(t);
    }
  }

  /// 批量保存
  Future<List<Object?>> saveAll(List<T> objects) async {
    Batch batch = executor.batch();
    for (var t in objects) {
      Map<String, dynamic> map = daoOpt.toMap(t);
      var id = daoOpt.getId(t);
      if (id != null) {
        batch.update(
          daoOpt.tableName,
          map,
          where: '${daoOpt.idName} = ?',
          whereArgs: [id],
        );
      } else {
        batch.insert(daoOpt.tableName, daoOpt.toMap(t));
      }
    }
    List ids = await batch.commit();
    for (int i = 0; i < objects.length; i++) {
      var id = daoOpt.getId(objects[i]);
      if (id == null) {
        daoOpt.setId(objects[i], ids[i]);
      }
    }
    return ids;
  }

  /// 统计
  Future<int> count({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    StringBuffer sb = StringBuffer("select count(0) from ${daoOpt.tableName} ");
    if (where != null && where.isNotEmpty) {
      sb.write('where $where');
    }
    List<Map<String, dynamic>> result = await executor.rawQuery(sb.toString(), whereArgs);
    return result.first.values.first ?? 0;
  }

  /// 查询全部
  Future<List<T>> findAll({
    String? where,
    List<dynamic>? whereArgs,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    List<Map<String, Object?>> result = await executor.query(
      daoOpt.tableName,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    return result.map((e) => daoOpt.fromMap(e)).toList();
  }

  /// 分页查询, [offset]和[page]是可选的，如果传入[page],则将自动转为[offset]
  Future<Page<T>> findPage({
    String? where,
    List<dynamic>? whereArgs,
    int limit = 10,
    int? offset,
    int? page,
    String? orderBy,
  }) async {
    offset = offset ?? ((page ?? 1) - 1) * limit;
    int $count = await count(where: where, whereArgs: whereArgs);
    List<T> data;
    if ($count == 0) {
      data = [];
    } else {
      data = await findAll(
        limit: limit,
        offset: offset,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
      );
    }
    return Page(limit: limit, offset: offset, count: $count, data: data);
  }

  /// 获取最后插入的主键
  Future<int?> lastRowId() async {
    String sql = "select last_insert_rowid() from ${daoOpt.tableName}";
    List<Map<String, dynamic>> result = await executor.rawQuery(sql);
    if (result.isNotEmpty) {
      return result[0].values.first;
    }
    return null;
  }

  /// 删除全部
  Future<int> deleteAll() async {
    return executor.delete(daoOpt.tableName);
  }

  /// 获取sql in的参数格式?
  static String sqlIn(int args, {String start = '', String end = ''}) {
    StringBuffer sb = StringBuffer(start);
    for (int i = 0; i < args; i++) {
      sb.write('?');
      if (i != args - 1) {
        sb.write(',');
      }
    }
    sb.write(end);
    return sb.toString();
  }
}

class Page<T> {
  /// 每页数量
  final int limit;

  /// 偏移量
  final int offset;

  /// 数据
  final List<T> data;

  /// 总数
  final int count;

  const Page({
    required this.limit,
    required this.offset,
    required this.data,
    required this.count,
  });

  /// 当前页码
  int get pageNo => offset ~/ limit + 1;

  /// 总页数
  int get pageCount => (count / limit).ceil();

  /// 是否是最后一页
  bool get isLast => pageNo >= pageCount;
}
