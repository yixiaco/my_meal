import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_meal/components/cookbook_ingredients_preview.dart';
import 'package:my_meal/components/cookbook_step_edit.dart';
import 'package:my_meal/components/cookbook_step_preview.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

class CookbookPreview extends StatefulHookConsumerWidget {
  const CookbookPreview({super.key, this.cookbook, this.steps, this.ingredients});

  final Cookbook? cookbook;
  final List<CookbookStep>? steps;
  final List<CookbookIngredients>? ingredients;

  @override
  ConsumerState<CookbookPreview> createState() => _CookbookEditState();
}

class _CookbookEditState extends ConsumerState<CookbookPreview> with AutomaticKeepAliveClientMixin {
  Cookbook _cookbook = Cookbook();
  List<CookbookStep> _steps = [];
  List<CookbookIngredients> _ingredients = [];

  Cookbook get effectiveCookbook => widget.cookbook ?? _cookbook;

  @override
  void initState() {
    if (widget.cookbook == null) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) async {
        if (mounted) {
          // 获取路由参数
          var arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments is Map<String, Object?>) {
            if (arguments case {'id': int id}) {
              var cookbook = await cookbookDaoSupport.findById(id);
              if (cookbook == null) {
                Navigator.maybePop(context);
                return;
              } else {
                setState(() {
                  _cookbook = cookbook;
                  _steps = CookbookStep.fromJsonArrayString(cookbook.stepJson);
                  _ingredients = CookbookIngredients.fromJsonArrayString(cookbook.ingredientsJson);
                });
              }
            } else {
              print('参数错误');
              Navigator.maybePop(context);
            }
          }
        }
      });
    } else {
      _steps = widget.steps ?? [];
      _ingredients = widget.ingredients ?? [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = TTheme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: _body(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return AppBar(
      leadingWidth: 40,
      // 左侧菜单按钮
      leading: IconButton(
        onPressed: () {
          Navigator.maybePop(context);
        },
        icon: Icon(Icons.close_rounded),
      ),
      actions: [
        if (widget.cookbook == null)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: colorScheme.bgColorSecondaryContainer,
              overlayColor: colorScheme.bgColorSecondaryContainerActive,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteQuery.cookbookEdit,
                  arguments: {'id': _cookbook.cookbookId});
            },
            child: Text('编辑', style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _body(TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (effectiveCookbook.coverImagePath != null)
            Image.file(
              File(effectiveCookbook.coverImagePath!),
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 菜谱标题
                Text(effectiveCookbook.title, style: theme.fontData.fontHeadlineMedium),
                Divider(height: 30, thickness: 0.5, color: colorScheme.borderLevel1Color),
                if (effectiveCookbook.subtitle != null)
                  // 菜谱描述
                  Text(effectiveCookbook.subtitle!, style: theme.fontData.fontBodyMedium),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 50,
                    children: [
                      if (effectiveIngredients.isNotEmpty) CookbookIngredientsPreview(effectiveIngredients),
                      if (effectiveSteps.isNotEmpty) CookbookStepPreview(effectiveSteps),
                      if (effectiveCookbook.updateTime != null)
                        Text(
                          '菜谱更新于 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(effectiveCookbook.updateTime!)}',
                          style: theme.fontData.fontBodySmall.copyWith(color: colorScheme.textColorPlaceholder),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<CookbookIngredients> get effectiveIngredients {
    return _ingredients.where((element) => element.name.isNotEmpty).toList();
  }

  List<CookbookStep> get effectiveSteps {
    return _steps.where((element) => element.description.isNotEmpty || element.imagePath != null).toList();
  }

  @override
  bool get wantKeepAlive => true;
}
