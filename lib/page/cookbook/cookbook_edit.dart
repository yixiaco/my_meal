import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/components/cookbook_ingredients_edit.dart';
import 'package:my_meal/components/cookbook_step_edit.dart';
import 'package:my_meal/components/toast.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

class CookbookEdit extends StatefulHookConsumerWidget {
  const CookbookEdit({super.key});

  @override
  ConsumerState<CookbookEdit> createState() => _CookbookEditState();
}

class _CookbookEditState extends ConsumerState<CookbookEdit> with AutomaticKeepAliveClientMixin {
  Cookbook _cookbook = Cookbook();
  List<CookbookStep> steps = [];
  List<CookbookIngredients> ingredients = [];
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (mounted) {
        // 获取路由参数
        var arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments is Map<String, Object?>) {
          if (arguments case {'path': String? path}) {
            setState(() {
              _cookbook.coverImagePath = path;
              steps = [];
              ingredients = [];
            });
          } else if(arguments case {'id': String? id}) {
            // TODO: 从数据库中读取菜谱信息
            setState(() {
              _cookbook = Cookbook();
              steps = [];
              ingredients = [];
            });
          } else {
            print('参数错误');
            Navigator.maybePop(context);
          }
        }
      }
    });
    _titleController.addListener(() {
      _cookbook.title = _titleController.text.trim();
      print(_cookbook.title);
    });
    _subtitleController.addListener(() {
      _cookbook.subtitle = _subtitleController.text.trim();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = TTheme.of(context);
    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: _body(context, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TThemeData theme) {
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
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.bgColorSecondaryContainer,
            overlayColor: colorScheme.bgColorSecondaryContainerActive,
          ),
          onPressed: () {},
          child: Text('预览', style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _body(BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_cookbook.coverImagePath != null)
              Image.file(
                File(_cookbook.coverImagePath!),
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
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '添加菜谱标题',
                      hintStyle: theme.fontData.fontHeadlineMedium.copyWith(color: colorScheme.textColorPlaceholder),
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    style: theme.fontData.fontHeadlineMedium,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入菜谱标题';
                      }
                      return null;
                    },
                  ),
                  Divider(height: 30, thickness: 0.5, color: colorScheme.borderLevel1Color),
                  // 菜谱描述
                  TextFormField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      hintText: '输入这道美食背后的故事',
                      hintStyle: theme.fontData.fontBodyMedium.copyWith(color: colorScheme.textColorPlaceholder),
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    style: theme.fontData.fontBodyMedium,
                  ),
                  SizedBox(height: 50),
                  CookbookIngredientsEdit(ingredients),
                  SizedBox(height: 50),
                  CookbookStepEdit(steps),
                ],
              ),
            ),
            _buildPublish(context, theme)
          ],
        ),
      ),
    );
  }

  /// 发布按钮
  Widget _buildPublish(BuildContext context, TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(
          height: 50,
          width: double.infinity,
          color: colorScheme.brandColor,
          alignment: Alignment.center,
          child: Text(
            '发布这个菜谱',
            style: TextStyle(
              color: colorScheme.textColorAnti,
              fontWeight: FontWeight.bold,
              fontSize: theme.fontData.fontSizeBodyMedium,
            ),
          ),
        ),
        onTap: () {
          var validateGranularly = _formKey.currentState!.validateGranularly();
          if (validateGranularly.isEmpty) {
            if (_cookbook.cookbookId == null) {
              _cookbook.createTime = DateTime.now();
              _cookbook.updateTime = DateTime.now();
            } else {
              _cookbook.updateTime = DateTime.now();
            }
            _cookbook.ingredientsJson = jsonEncode(ingredients);
            _cookbook.stepJson = jsonEncode(steps);
            // TODO: 将图片移动到系统文件夹中，并改变对象中的图片地址
            // 保存到数据库中
            cookbookDaoSupport.saveOrUpdate(_cookbook);
          } else {
            ToastHold.show(
              context,
              icon: Icons.error_outline_rounded,
              validateGranularly.first.errorText!,
              gravity: ToastGravity.TOP,
              toastDuration: Duration(seconds: 2),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
