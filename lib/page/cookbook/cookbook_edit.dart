import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/components/camera_and_gallery_bottom_sheet.dart';
import 'package:my_meal/components/cookbook_ingredients_edit.dart';
import 'package:my_meal/components/cookbook_step_edit.dart';
import 'package:my_meal/components/toast.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/page/cookbook/cookbook_preview.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/state/states.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';
import 'package:my_meal/util/image_file_util.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) async {
      if (mounted) {
        // 获取路由参数
        var arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments is Map<String, Object?>) {
          if (arguments case {'path': String? path}) {
            setState(() {
              _cookbook.coverImagePath = path;
              steps = [];
              ingredients = [];
              _initCookbook();
            });
          } else if (arguments case {'id': int id}) {
            var cookbook = await cookbookDaoSupport.findById(id);
            if (cookbook == null) {
              Navigator.maybePop(context);
              return;
            } else {
              setState(() {
                _cookbook = cookbook;
                steps = CookbookStep.fromJsonArrayString(cookbook.stepJson);
                ingredients = CookbookIngredients.fromJsonArrayString(cookbook.ingredientsJson);
                _initCookbook();
              });
            }
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

  void _initCookbook() {
    _titleController.text = _cookbook.title;
    _subtitleController.text = _cookbook.subtitle ?? '';
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (context, didPop) {
        // TODO： 提示未保存
      },
      child: Scaffold(
        appBar: _buildAppBar(theme),
        body: _body(theme),
      ),
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
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.bgColorSecondaryContainer,
            overlayColor: colorScheme.bgColorSecondaryContainerActive,
          ),
          onPressed: () {
            // 预览需要传递对象过去
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => CookbookPreview(
                cookbook: _cookbook,
                steps: steps,
                ingredients: ingredients,
              ),
            ));
          },
          child: Text('预览', style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _body(TThemeData theme) {
    var colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_cookbook.coverImagePath != null)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showCameraAndGalleryBottomSheet(context, (image) async {
                      // 获取文件扩展名
                      var name = image.name.contains('.') ? '.${image.name.split('.').last}' : '';

                      var tempPath = await ImageFileUtil.copyBytesToTempFile(await image.readAsBytes(), extension: name);

                      Logger.root.info('临时文件：$tempPath');
                      setState(() {
                        _cookbook.coverImagePath = tempPath;
                      });
                    });
                  },
                  child: Image.file(
                    File(_cookbook.coverImagePath!),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
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
            _buildPublish(theme)
          ],
        ),
      ),
    );
  }

  /// 发布按钮
  Widget _buildPublish(TThemeData theme) {
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
        onTap: () async {
          var validateGranularly = _formKey.currentState!.validateGranularly();
          if (validateGranularly.isEmpty) {
            _cookbook.ingredientsJson = jsonEncode(ingredients);
            _cookbook.stepJson = jsonEncode(steps);
            if (_cookbook.cookbookId == null) {
              _cookbook.createTime = DateTime.now();
              _cookbook.updateTime = DateTime.now();
              // 保存到数据库中, 以获取新的cookbookId
              await cookbookDaoSupport.saveOrUpdate(_cookbook);
            } else {
              _cookbook.updateTime = DateTime.now();
            }
            // 将图片移动到菜谱文件夹中，并改变对象中的图片地址
            await ImageFileUtil.saveCookbookImage(_cookbook, steps);
            // 更新步骤
            _cookbook.stepJson = jsonEncode(steps);

            Logger.root.info('保存或更新菜谱： $_cookbook');

            // 保存到数据库中
            await cookbookDaoSupport.saveOrUpdate(_cookbook);

            // 清除临时文件
            await ImageFileUtil.clearTempFiles();

            ref.refresh(refreshProvider);
            Navigator.maybePop(context);
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
