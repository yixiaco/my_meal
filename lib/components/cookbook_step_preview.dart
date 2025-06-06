import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';
import 'package:my_meal/theme/var.dart';

import 'image_preview.dart';

class CookbookStepPreview extends StatelessWidget {
  const CookbookStepPreview(this.steps, {super.key});

  final List<CookbookStep> steps;

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text('做法', style: theme.fontData.fontTitleMedium),
        for (int i = 0; i < steps.length; i++) _buildStepItem(steps[i], i, context, theme),
      ],
    );
  }

  Widget _buildStepItem(CookbookStep step, int index, BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('步骤${index + 1}', style: theme.fontData.fontTitleSmall),
        if (step.imagePath != null)
          Material(
            elevation: 0.5,
            borderRadius: BorderRadius.circular(ThemeVar.borderRadiusExtraLarge),
            color: colorScheme.bgColorSecondaryContainer,
            clipBehavior: Clip.antiAlias,
            child: PhotoViewScreen(
              imageUrl: step.imagePath!,
              heroTag: step.hashCode.toString(),
              child: SizedBox(
                height: 250,
                child: Image.file(
                  File(step.imagePath!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        SelectableText(step.description, style: theme.fontData.fontBodyMedium),
      ],
    );
  }
}
