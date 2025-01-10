import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_meal/generated/assets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

/// 数据库版本
const kVersion1 = 1;

class Db {
  Db._();

  static Database? _db;

  /// 初始化数据库对象
  static Future<void> init() async {
    _db ??= await _initDB();
  }

  static Database get db => _db!;

  static Future<Database> _initDB() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      initFfi();
      return await databaseFactoryFfi.openDatabase(
        join(Directory.current.path, 'data', 'data.db'),
        options: OpenDatabaseOptions(
          version: kVersion1,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
    } else {
      return await openDatabase('data.db', version: kVersion1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    }
  }

  static void initFfi() {
    if (kReleaseMode) {
      /// 如果是发布模式
      if (Platform.isWindows) {
        windowsInit();
      }
    } else {
      sqfliteFfiInit();
    }
  }

  /// On windows load the embedded sqlite3.dll for convenience
  static void windowsInit() {
    var path = normalize(join('data', 'flutter_assets', 'assets', 'dll', 'sqlite3.dll'));
    open.overrideFor(OperatingSystem.windows, () {
      // devPrint('loading $path');
      try {
        return DynamicLibrary.open(path);
      } catch (e) {
        stderr.writeln('Failed to load sqlite3.dll at $path');
        rethrow;
      }
    });

    // Force an open in the main isolate
    // Loading from an isolate seems to break on windows
    sqlite3.sqlite3.openInMemory().dispose();
  }

  ///
  /// 创建Table
  ///
  static Future<void> _onCreate(Database db, int version) async {
    String sql = await PlatformAssetBundle().loadString(Assets.sqlInit);
    await db.execute(sql);
  }

  ///
  /// 更新Table
  ///
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i < newVersion; i++) {
      String nextVersion = await PlatformAssetBundle().loadString("assets/sql/v${i + 1}.sql");
      if (nextVersion.isNotEmpty) {
        await db.execute(nextVersion);
      }
    }
  }

  void close() async {
    await _db?.close();
    _db = null;
  }
}
