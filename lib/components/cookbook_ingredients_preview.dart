import 'package:flutter/material.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

import 'divider.dart';

/// 菜谱中的食材输入框和用量输入框
class CookbookIngredientsPreview extends StatelessWidget {
  const CookbookIngredientsPreview(this.ingredients, {super.key});

  final List<CookbookIngredients> ingredients;

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('用料', style: theme.fontData.fontTitleMedium),
        if (ingredients.isNotEmpty) SizedBox(height: 20),
        for (var ingredient in ingredients) ...[
          _buildIngredients(ingredient, context, theme),
          TDivider(dashed: true, thickness: 1),
        ],
      ],
    );
  }

  /// 构建食材输入框和用量输入框
  Widget _buildIngredients(CookbookIngredients ingredient, BuildContext context, TThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(ingredient.name, style: theme.fontData.fontBodyMedium),
        SelectableText(ingredient.dosage, style: theme.fontData.fontBodyMedium),
      ],
    );
  }
}
