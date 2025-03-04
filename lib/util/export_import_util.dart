import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dartx/dartx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/components/toast.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/model/cookbook.dart';

import 'image_file_util.dart';

final RegExp _split = RegExp(r'[\\/]+');

/// 导出导入工具
class ExportImportUtil {
  /// 压缩菜谱到zip文件中
  /// 返回zip字节
  static Future<Uint8List> compressCookbookToZip(Iterable<int> ids) async {
    var list = await cookbookDaoSupport.findByIds(ids.toList());
    var archive = Archive();
    for (var ele in list) {
      var dto = CookbookDto.fromCookbook(ele);
      var steps = dto.steps;
      var cookbook = dto.cookbook;
      var title = cookbook.title;

      // 添加封面图片
      var coverImagePath = cookbook.coverImagePath;
      if (coverImagePath?.isNotBlank == true) {
        var path = coverImagePath;
        // 重写图片路径
        cookbook.coverImagePath = coverImagePath?.split(_split).last;
        var archiveFile = ArchiveFile.stream("$title/images/${cookbook.coverImagePath}", InputFileStream(path!));
        archive.add(archiveFile);
      }

      // 添加步骤图片
      for (var step in steps) {
        var imagePath = step.imagePath;
        if (imagePath != null && imagePath.isNotBlank) {
          var path = imagePath;
          // 重写图片路径
          step.imagePath = imagePath.split(_split).last;
          var archiveFile = ArchiveFile.stream("$title/images/${step.imagePath}", InputFileStream(path));
          archive.add(archiveFile);
        }
      }

      // 转为json
      var jsonStr = dto.toJson();
      // 使用 utf8.encode 将字符串转换为字节数组
      List<int> bytes = utf8.encode(jsonStr);
      var jsonFile = ArchiveFile.bytes("$title/cookbook.json", bytes);
      archive.add(jsonFile);
    }
    // 将Archive转换成ZIP格式的Uint8List
    return ZipEncoder().encodeBytes(archive);
  }

  /// 导出菜谱到文件
  static Future<bool> exportCookbookToFile(Iterable<int> ids, BuildContext context) async {
    var zipData = await compressCookbookToZip(ids);
    var outputFile = await FilePicker.platform.saveFile(
      dialogTitle: '保存菜谱',
      fileName: 'cookbook-output.zip',
      bytes: zipData,
    );

    if (outputFile == null) {
      // User canceled the picker
      return false;
    }
    if (kDebugMode) {
      print('选择的保存路径为：$outputFile');
    }

    // 示例：将一些文本写入到选中的文件路径
    try {
      await File(outputFile).writeAsBytes(zipData);
      Logger.root.info('文件已保存: $outputFile');
      ToastHold.show(
        context,
        icon: Icons.check,
        '文件已保存: $outputFile',
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      Logger.root.severe('保存文件时出错: $e');
      ToastHold.show(
        context,
        icon: Icons.error_outline_rounded,
        '保存文件时出错: $e',
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(seconds: 5),
      );
      return false;
    }
  }

  /// 导入菜谱
  static void importCookbook({VoidCallback? computed}) async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null) {
      // User canceled the picker
      return;
    }
    var path = result.files.single.path;
    if (path == null) {
      return;
    }
    final inputStream = InputFileStream(path);
    // Decode the zip from the InputFileStream. The archive will have the contents of the
    // zip, without having stored the data in memory.
    final archive = ZipDecoder().decodeStream(inputStream);

    // 测试4/images/e9468d292f66e150e540165c9e1d8429.png, isFile: true
    // 测试4/cookbook.json, isFile: true
    // 测试5/images/c7f4d4228adf8268c9290abfc399c9c2.jpg, isFile: true
    // 测试5/cookbook.json, isFile: true
    var group = archive.filter((element) => element.isFile).groupBy((element) => element.name.split(_split).first);

    for (var entry in group.entries) {
      var key = entry.key;
      var value = entry.value;
      Map<String, ArchiveFile> images = {};
      ArchiveFile? cookbookJsonFile;
      for (var element in value) {
        var name = element.name;
        if (name.endsWith('cookbook.json')) {
          cookbookJsonFile = element;
        } else {
          images[element.name.split(_split).last] = element;
        }
      }
      if (cookbookJsonFile == null) {
        continue;
      }
      var jsonStr = utf8.decode(cookbookJsonFile.readBytes()!);
      var dto = CookbookDto.fromJson(jsonStr);
      var cookbook = dto.cookbook;
      // 重置主键和创建时间
      cookbook.cookbookId = null;
      cookbook.createTime = DateTime.now();
      cookbook.updateTime = DateTime.now();
      await cookbookDaoSupport.insert(cookbook);
      await ImageFileUtil.saveZipCookbookImage(dto, images);
      await cookbookDaoSupport.update(dto.cookbook);
    }
    computed?.call();
  }
}
