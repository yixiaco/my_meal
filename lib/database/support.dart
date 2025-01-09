import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';

mixin DaoObject {
  setId(dynamic id);

  Map<String, dynamic> toMap();
}

/// 支持数据库操作
///
/// example:
/// ```dart
/// class DemoDao extends DaoSupport<Demo> {
///
///   DemoDao._();
///
///   DemoDao instance = DemoDao._();
///
///   @override
///   get idName => 'id';
///
///   @override
///   get tableName => 'table';
///
///   @override
///   T fromMap(dynamic map) => Demo.fromMap(map);
/// }
/// ```
mixin DaoSupport<T extends DaoObject> {
  /// 主键名称
  String get idName;

  /// 表名
  String get tableName;

  T fromMap(dynamic map);

  DatabaseExecutor get executor => _transaction ?? Db.db;

  Transaction? _transaction;

  /// 批量事务注入
  ///
  /// example:
  /// ```dart
  /// await DaoSupport.transaction([DemoDao1.instance, DemoDao2.instance], () {
  ///   DemoDao1.instance.insert(Demo1());
  ///   DemoDao2.instance.insert(Demo2());
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
      return fromMap(list[0]);
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
      tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );
    if (list.isNotEmpty) {
      return fromMap(list[0]);
    }
    return null;
  }

  /// 主键查询
  Future<T?> findById(dynamic id) async {
    List<Map<String, Object?>> list = await executor.query(
      tableName,
      where: '$idName = ?',
      whereArgs: [id],
    );
    if (list.isNotEmpty) {
      return fromMap(list[0]);
    }
    return null;
  }

  /// 多主键查询
  Future<List<T>> findByIds(List<dynamic> ids) async {
    List<Map<String, Object?>> list = await executor.query(
      tableName,
      where: '$idName in(${DaoSupport.sqlIn(ids.length)})',
      whereArgs: ids,
    );
    if (list.isNotEmpty) {
      return list.map((e) => fromMap(e)).toList();
    }
    return List.empty();
  }

  /// 删除
  Future<int> deleteById(dynamic id) async {
    return executor.delete(
      tableName,
      where: '$idName = ?',
      whereArgs: [id],
    );
  }

  /// 批量删除
  Future<List<Object?>> batchDeleteById(List<dynamic> ids) async {
    Batch batch = executor.batch();
    for (var id in ids) {
      batch.delete(
        tableName,
        where: '$idName = ?',
        whereArgs: [id],
      );
    }
    return batch.commit();
  }

  /// 插入
  Future<int> insert(T t) async {
    int id = await executor.insert(tableName, t.toMap());
    t.setId(id);
    return id;
  }

  /// 批量插入
  Future<List<Object?>> batchInsert(List<T> objects) async {
    Batch batch = executor.batch();
    for (var value in objects) {
      batch.insert(tableName, value.toMap());
    }
    List ids = await batch.commit();
    for (int i = 0; i < objects.length; i++) {
      objects[i].setId(ids[i]);
    }
    return ids;
  }

  /// 更新
  Future<int> update(T t) async {
    Map<String, dynamic> map = t.toMap();
    dynamic id = map[idName];
    assert(id != null, 'id cannot be null');
    return executor.update(
      tableName,
      map,
      where: '$idName = ?',
      whereArgs: [id],
    );
  }

  /// 批量更新
  Future<List<Object?>> batchUpdate(List<T> objects) async {
    Batch batch = executor.batch();
    for (var value in objects) {
      Map<String, dynamic> map = value.toMap();
      dynamic id = map[idName];
      assert(id != null, 'id cannot be null');
      batch.update(
        tableName,
        map,
        where: '$idName = ?',
        whereArgs: [id],
      );
    }
    return batch.commit();
  }

  /// 保存
  Future<int> save(T t) async {
    Map<String, dynamic> map = t.toMap();
    dynamic id = map[idName];
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
      Map<String, dynamic> map = t.toMap();
      dynamic id = map[idName];
      if (id != null) {
        batch.update(
          tableName,
          map,
          where: '$idName = ?',
          whereArgs: [id],
        );
      } else {
        batch.insert(tableName, t.toMap());
      }
    }
    List ids = await batch.commit();
    for (int i = 0; i < objects.length; i++) {
      Map<String, dynamic> map = objects[i].toMap();
      if (map[idName] == null) {
        objects[i].setId(ids[i]);
      }
    }
    return ids;
  }

  /// 统计
  Future<int> count({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    StringBuffer sb = StringBuffer("select count(0) from $tableName ");
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
      tableName,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    return result.map((e) => fromMap(e)).toList();
  }

  /// 分页查询
  Future<Page<T>> findPage({
    String? where,
    List<dynamic>? whereArgs,
    int limit = 10,
    int offset = 0,
    String? orderBy,
  }) async {
    int _count = await count(where: where, whereArgs: whereArgs);
    List<T> data;
    if (_count == 0) {
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
    return Page(limit: limit, offset: offset, count: _count, data: data);
  }

  /// 获取最后插入的主键
  Future<int?> lastRowId() async {
    String sql = "select last_insert_rowid() from $tableName";
    List<Map<String, dynamic>> result = await executor.rawQuery(sql);
    if (result.isNotEmpty) {
      return result[0].values.first;
    }
    return null;
  }

  /// 删除全部
  Future<int> deleteAll() async {
    return executor.delete(tableName);
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
  final int limit;
  final int offset;
  final List<T> data;
  final int count;

  const Page({
    required this.limit,
    required this.offset,
    required this.data,
    required this.count,
  });
}
