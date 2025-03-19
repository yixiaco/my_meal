import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({
    super.key,
    required this.imageUrl,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.heroTag,
    required this.child,
  });

  /// 图片
  final String imageUrl;

  /// 背景修饰
  final BoxDecoration? backgroundDecoration;

  /// 最大缩放倍数
  final dynamic minScale;

  /// 最小缩放倍数
  final dynamic maxScale;

  /// hero动画tagid
  final String heroTag;

  /// 组件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return PhotoViewSimpleScreen(
                imageProvider: FileImage(File(imageUrl)),
                heroTag: heroTag,
                backgroundDecoration: backgroundDecoration,
                minScale: minScale,
                maxScale: maxScale,
              );
            },
          ));
        },
        child: Hero(
          tag: heroTag,
          child: child,
        ),
      ),
    );
  }
}

class PhotoViewSimpleScreen extends StatelessWidget {
  const PhotoViewSimpleScreen({
    super.key,
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.heroTag,
  });

  /// 图片
  final ImageProvider imageProvider;

  /// 背景修饰
  final BoxDecoration? backgroundDecoration;

  /// 最大缩放倍数
  final dynamic minScale;

  /// 最小缩放倍数
  final dynamic maxScale;

  /// hero动画tagid
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: PhotoView(
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration,
          heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
          initialScale: PhotoViewComputedScale.contained,
          minScale: minScale ?? PhotoViewComputedScale.contained * 0.8,
          maxScale: maxScale ?? PhotoViewComputedScale.covered * 1.8,
          enableRotation: true,
        ),
      ),
    );
  }
}
