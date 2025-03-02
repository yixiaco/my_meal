import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/theme/var.dart';

typedef OnPickImageCallback = FutureOr<void> Function(XFile image);

/// 底部弹出相机和相册选择
void showCameraAndGalleryBottomSheet(BuildContext context, OnPickImageCallback onPickImage) {
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
                GestureDetector(
                  onTap: () async {
                    await _jump(context, ImageSource.camera, onPickImage);
                  },
                  child: Tab(icon: Icon(Icons.camera_alt), text: '相机'),
                ),
              GestureDetector(
                onTap: () async {
                  await _jump(context, ImageSource.gallery, onPickImage);
                },
                child: Tab(icon: Icon(Icons.photo), text: '相册'),
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

Future<void> _jump(BuildContext context, ImageSource source, OnPickImageCallback onPickImage) async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? image = await picker.pickImage(source: source);
  Logger.root.info('path: ${image?.path}, name: ${image?.name}');
  if (image != null) {
    // 先关闭底部弹窗再跳转
    Navigator.pop(context);
    await onPickImage(image);
  }
}
