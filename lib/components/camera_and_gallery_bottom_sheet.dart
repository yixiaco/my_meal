import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/components/toast.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/theme/var.dart';
import 'package:my_meal/util/export_import_util.dart';

import 'custom_tab.dart';

typedef OnPickImageCallback = FutureOr<void> Function(XFile image);

/// 底部弹出相机和相册选择
void showCameraAndGalleryBottomSheet(
  BuildContext context, {
  OnPickImageCallback? onPickImage,
  useImport = true,
  VoidCallback? importComputed,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) => BottomSheet(
      enableDrag: false,
      elevation: 4,
      backgroundColor: Colors.transparent,
      onClosing: () {
        if (kDebugMode) {
          print('onClosing');
        }
      },
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (Platform.isAndroid || Platform.isIOS)
                CustomTab(
                  icon: TIcons.camera_filled,
                  text: '相机',
                  onPressed: () async {
                    await _jump(context, ImageSource.camera, onPickImage);
                  },
                ),
              CustomTab(
                icon: TIcons.image_search_filled,
                text: '相册',
                onPressed: () async {
                  await _jump(context, ImageSource.gallery, onPickImage);
                },
              ),
              if (useImport)
                CustomTab(
                  icon: TIcons.download_1,
                  text: '导入',
                  onPressed: () async {
                    ExportImportUtil.importCookbook(context, computed: (count) {
                      if (count == 0) {
                        ToastHold.warning(context, '未发现菜谱文件');
                      } else {
                        ToastHold.success(context, '导入完成，共导入 $count 个菜谱');
                        importComputed?.call();
                      }
                      Navigator.pop(context);
                    });
                  },
                ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(ThemeVar.borderRadiusMedium)),
    ),
    useSafeArea: true,
  );
}

Future<void> _jump(BuildContext context, ImageSource source, OnPickImageCallback? onPickImage) async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? image = await picker.pickImage(source: source);
  Logger.root.info('path: ${image?.path}, name: ${image?.name}');
  if (image != null) {
    // 先关闭底部弹窗再跳转
    Navigator.pop(context);
    await onPickImage?.call(image);
  }
}
