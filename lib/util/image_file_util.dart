import 'dart:io';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/foundation.dart';
import 'package:my_meal/basic/global.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageFileUtil {
  /// 将asset中的图片拷贝到临时目录中
  static Future<String?> copyAssetToTempFile(String path) async {
    var file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    // 读取图片
    var bytes = await file.readAsBytes();
    return await copyBytesToTempFile(bytes, extension: file.extension);
  }

  /// 将字节拷贝到临时目录中
  ///
  /// [extension] .jpg .png 等等
  static Future<String?> copyBytesToTempFile(Uint8List bytes, {String extension = ""}) async {
    // 计算md5
    var digest = md5.convert(bytes);
    final Directory dir = await getTemporaryDirectory();

    var tempDir = normalize(join(dir.path, Global.packageInfo.packageName));
    if (kDebugMode) {
      print(tempDir);
    }
    // 生成文件名
    final String targetFilePath = normalize(join(tempDir, digest.toString() + extension));

    // 确保目标目录存在
    await Directory(tempDir).create(recursive: true);

    await File(targetFilePath).writeAsBytes(bytes);
    return targetFilePath;
  }

  /// 将asset中的图片移动到数据目录中
  ///
  /// [id] 为菜谱的id，用于生成文件夹名，将图片保存到以菜谱id命名的文件夹中
  static Future<String?> copyAssetToDataDir(String path, int id) async {
    var file = File(path);

    if (!file.existsSync()) {
      return null;
    }

    String targetFilePath = await getSaveFile(id, file.name);
    // 复制
    await file.copy(targetFilePath);
    return targetFilePath;
  }

  /// 清除临时文件
  static Future<void> clearTempFiles() async {
    final Directory dir = await getTemporaryDirectory();
    var temp = join(dir.path, Global.packageInfo.packageName);
    var directory = Directory(temp);
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }

  /// 保存菜谱图片到文档目录中
  static Future<void> saveCookbookImage(CookbookDto dto) async {
    var cookbook = dto.cookbook;
    var steps = dto.steps;
    var cookbookId = cookbook.cookbookId;
    if (cookbookId == null) {
      return;
    }
    var dir = await getSaveDirectory();
    var targetDir = join(dir.path, cookbookId.toString());
    if (cookbook.coverImagePath != null && !cookbook.coverImagePath!.startsWith(targetDir)) {
      cookbook.coverImagePath = await copyAssetToDataDir(cookbook.coverImagePath!, cookbookId);
    }

    if (steps.isNotEmpty) {
      for (var value in steps) {
        if (value.imagePath != null && !value.imagePath!.startsWith(targetDir)) {
          value.imagePath = await copyAssetToDataDir(value.imagePath!, cookbookId);
        }
      }
    }
  }

  /// 保存字节菜谱图片到文档目录中
  static Future<void> saveZipCookbookImage(CookbookDto dto, Map<String, ArchiveFile> imageMap) async {
    var cookbook = dto.cookbook;
    var steps = dto.steps;
    var cookbookId = cookbook.cookbookId;
    if (cookbookId == null) {
      return;
    }

    if (cookbook.coverImagePath != null) {
      var path = cookbook.coverImagePath!;
      var file = imageMap[path];
      if (file == null) {
        return;
      }
      var targetFilePath = await getSaveFile(cookbookId, path);
      cookbook.coverImagePath = targetFilePath;
      await File(targetFilePath).writeAsBytes(file.readBytes()!);
    }

    if (steps.isNotEmpty) {
      for (var value in steps) {
        if (value.imagePath != null) {
          var path = value.imagePath!;
          var file = imageMap[path];
          if (file == null) {
            value.imagePath = null;
            continue;
          }
          var targetFilePath = await getSaveFile(cookbookId, path);
          value.imagePath = targetFilePath;
          await File(targetFilePath).writeAsBytes(file.readBytes()!);
        }
      }
    }
  }

  /// 删除菜谱图片
  static Future<void> deleteCookbookIds(List<int> cookbookIds) async {
    var dir = await getSaveDirectory();
    await Future.forEach(cookbookIds, (cookbookId) {
      var targetDir = join(dir.path, cookbookId.toString());
      if (Directory(targetDir).existsSync()) {
        return Directory(targetDir).delete(recursive: true);
      }
    });
  }

  /// 获取保存目标文件
  static Future<String> getSaveFile(int id, String name) async {
    Directory dir = await getSaveDirectory();
    final String targetDirPath = normalize(join(dir.path, id.toString()));
    final String targetFilePath = normalize(join(dir.path, id.toString(), name));
    var targetFile = File(targetFilePath);
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }
    // 确保目标目录存在
    await Directory(targetDirPath).create(recursive: true);
    return targetFilePath;
  }

  /// 获取保存目录
  static Future<Directory> getSaveDirectory() async {
    final Directory dir = await getApplicationSupportDirectory();
    return dir;
  }
}
