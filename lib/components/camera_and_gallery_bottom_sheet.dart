import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showCameraAndGalleryBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => BottomSheet(
      enableDrag: true,
      elevation: 4,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(60),
      //   topLeft: Radius.circular(60),
      // )),
      backgroundColor: Colors.transparent,
      onClosing: () => print('onClosing'),
      // builder: (_) => Container(
      //   padding: EdgeInsets.symmetric(vertical: 15),
      //   child: Text('data'),
      // ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (Platform.isAndroid || Platform.isIOS)
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an camera.
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  print('path: ${image?.path}, name: ${image?.name}');
                },
                child: Tab(icon: Icon(Icons.camera_alt), text: '相机'),
              ),
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  print('path: ${image?.path}, name: ${image?.name}');
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
      borderRadius: BorderRadius.zero,
    ),
    useSafeArea: true,
  );
}
