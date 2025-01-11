import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/components/camera_and_gallery_bottom_sheet.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';
import 'package:my_meal/theme/var.dart';

class CookbookStepEdit extends StatefulHookConsumerWidget {
  const CookbookStepEdit(this.steps, {super.key});

  final List<CookbookStep> steps;

  @override
  ConsumerState<CookbookStepEdit> createState() => _CookbookStepEditState();
}

class _CookbookStepEditState extends ConsumerState<CookbookStepEdit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CookbookStepEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.steps.isEmpty) {
      widget.steps.add(CookbookStep());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text('做法', style: theme.fontData.fontTitleMedium),
        for (int i = 0; i < widget.steps.length; i++) _buildStepItem(widget.steps[i], i, context, theme),
        _buildButton(context, theme),
      ],
    );
  }

  Widget _buildStepItem(CookbookStep step, int index, BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    var textEditingController = useTextEditingController(text: step.description);

    Widget child;
    if (step.imagePath != null) {
      child = Image.file(
        File(step.imagePath!),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      child = Center(
        child: DefaultTextStyle(
          style: theme.fontData.fontBodyMedium.copyWith(color: colorScheme.textColorPlaceholder),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('+步骤图'), Text('清晰的步骤会让菜谱更受欢迎')],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text('步骤${index + 1}', style: theme.fontData.fontTitleSmall),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showCameraAndGalleryBottomSheet(context, (image) {
                setState(() {
                  step.imagePath = image.path;
                });
              });
            },
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeVar.borderRadiusExtraLarge),
                color: colorScheme.bgColorSecondaryContainer,
              ),
              child: child,
            ),
          ),
        ),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: '添加步骤说明',
            hintStyle: theme.fontData.fontBodyLarge.copyWith(color: colorScheme.textColorPlaceholder),
            border: InputBorder.none,
            isCollapsed: true,
          ),
          maxLines: null,
          style: theme.fontData.fontBodyLarge,
        )
      ],
    );
  }

  Widget _buildButton(BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.bgColorSecondaryContainer,
            overlayColor: colorScheme.bgColorSecondaryContainerActive,
          ),
          onPressed: () {},
          child: Text(
            '调整步骤',
            style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold, height: 3),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.bgColorSecondaryContainer,
            overlayColor: colorScheme.bgColorSecondaryContainerActive,
          ),
          onPressed: () {
            setState(() {
              widget.steps.add(CookbookStep());
            });
          },
          child: Text(
            '再增加一步',
            style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold, height: 3),
          ),
        ),
      ],
    );
  }
}
