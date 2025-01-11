import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

/// 菜谱中的食材输入框和用量输入框
class CookbookIngredientsEdit extends StatefulHookConsumerWidget {
  const CookbookIngredientsEdit(this.ingredients, {super.key});

  final List<CookbookIngredients> ingredients;

  @override
  ConsumerState<CookbookIngredientsEdit> createState() => _CookbookIngredientsEditState();
}

class _CookbookIngredientsEditState extends ConsumerState<CookbookIngredientsEdit> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CookbookIngredientsEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ingredients.isEmpty) {
      widget.ingredients.add(CookbookIngredients());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    var colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('用料', style: theme.fontData.fontTitleMedium),
        SizedBox(height: 20),
        for (var ingredient in widget.ingredients)
          ...[_buildIngredients(ingredient, context, theme), Divider(thickness: 0.5, color: colorScheme.borderLevel1Color)],
        SizedBox(height: 20),
        _buildButton(context, theme),
      ],
    );
  }

  /// 构建食材输入框和用量输入框
  Widget _buildIngredients(CookbookIngredients ingredient, BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    var textEditingController1 = useTextEditingController(text: ingredient.name);
    var textEditingController2 = useTextEditingController(text: ingredient.dosage);
    var padding = EdgeInsets.symmetric(vertical: 8);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: textEditingController1,
            decoration: InputDecoration(
              hintText: '食材：如鸡蛋',
              hintStyle: theme.fontData.fontBodyMedium.copyWith(color: colorScheme.textColorPlaceholder),
              border: InputBorder.none,
              isDense: true,
              contentPadding: padding,
            ),
            onChanged: (value) {
              ingredient.name = value;
            },
            style: theme.fontData.fontBodyMedium,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: textEditingController2,
            decoration: InputDecoration(
              hintText: '用量：如1个',
              hintStyle: theme.fontData.fontBodyMedium.copyWith(color: colorScheme.textColorPlaceholder),
              border: InputBorder.none,
              isDense: true,
              contentPadding: padding,
            ),
            onChanged: (value) {
              ingredient.dosage = value;
            },
            style: theme.fontData.fontBodyMedium,
          ),
        ),
      ],
    );
  }

  /// 构建添加和增加一行按钮
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
            '调整用料',
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
              widget.ingredients.add(CookbookIngredients());
            });
          },
          child: Text(
            '再增加一行',
            style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold, height: 3),
          ),
        ),
      ],
    );
  }

}
