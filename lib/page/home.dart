import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/components/app_bar_input.dart';
import 'package:my_meal/components/camera_and_gallery_bottom_sheet.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/state/states.dart';
import 'package:my_meal/theme/color_scheme.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';
import 'package:my_meal/util/debounced.dart';
import 'package:my_meal/util/image_file_util.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// 选中id集合
  final Set<int> _selectedId = {};

  /// 是否开启选择模式
  bool _isSelectMode = false;

  /// 搜索框控制器
  late TextEditingController _searchTextController;

  /// 列表数据
  List<Cookbook> cookbooks = [];

  /// 搜索框输入框改变防抖事件
  final debounced = Debounced(milliseconds: 300);

  late Future<List<Cookbook>> _future;

  @override
  void initState() {
    _searchTextController = TextEditingController();
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
    debounced.dispose();
  }

  int get itemCount => cookbooks.length;

  @override
  Widget build(BuildContext context) {
    var themeData = TTheme.of(context);
    var colorScheme = themeData.colorScheme;

    ref.listen(refreshProvider, (previous, next) {
      _loadData();
    });

    return PopScope(
      canPop: !_isSelectMode,
      onPopInvokedWithResult: (didPop, result) {
        // 当发生了返回事件时，关闭选择模式
        _closeSelect();
      },
      child: Scaffold(
        appBar: _buildArrBar(themeData),
        body: _buildBody(colorScheme),
        floatingActionButton: _buildFloatingActionButton(colorScheme),
      ),
    );
  }

  /// 构建浮动删除按钮
  Widget? _buildFloatingActionButton(TColorScheme colorScheme) {
    return _isSelectMode && _selectedId.isNotEmpty
        ? FloatingActionButton(
            onPressed: () async {
              await deleteIds(_selectedId.toList());
              _closeSelect();
              _loadData();
            },
            mini: true,
            backgroundColor: colorScheme.errorColor,
            child: Icon(TIcons.delete, size: 16),
          )
        : null;
  }

  /// 构建appbar
  PreferredSizeWidget _buildArrBar(TThemeData themeData) {
    Widget iconButton;
    Widget? leading;
    Widget title;
    if (_isSelectMode) {
      // 选择模式下，显示全选按钮
      iconButton = IconButton(
        onPressed: toggleSelectAll,
        icon: Icon(
          _selectedId.length == itemCount ? Icons.add_box_rounded : Icons.add_box_outlined,
        ),
      );
      leading = IconButton(onPressed: _closeSelect, icon: Icon(Icons.close_rounded));
      title = Text('已选择${_selectedId.length}项', style: TextStyle(fontSize: themeData.fontData.fontSizeTitleMedium));
    } else {
      iconButton = GestureDetector(
        onTap: createCookbook,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Icon(Icons.add_circle_outline_rounded),
        ),
      );
      // leading = Builder(builder: (context) {
      //   return IconButton(
      //     onPressed: () {
      //       Scaffold.of(context).openDrawer();
      //     },
      //     icon: Icon(Icons.menu_rounded),
      //     hoverColor: Colors.transparent,
      //     highlightColor: Colors.transparent,
      //   );
      // });
      title = AppBarInput(
        controller: _searchTextController,
        onChanged: (value) {
          debounced.run(() {
            _loadData();
          });
        },
      );
    }

    return AppBar(
      leadingWidth: 40,
      // 中间的搜索框
      title: title,
      // 左侧菜单按钮
      leading: leading,
      // 右侧按钮
      actions: [iconButton],
    );
  }

  /// 构建body
  Widget _buildBody(TColorScheme colorScheme) {
    return FutureBuilder<List<Cookbook>>(
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          cookbooks = snapshot.data!;
        }
        if (cookbooks.isEmpty) {
          if (_searchTextController.text.trim().isEmpty) {
            return Container(
              color: colorScheme.bgColorContainer,
              child: Center(child: FilledButton(onPressed: createCookbook, child: Text('新建菜谱'))),
            );
          } else {
            return Container(
              color: colorScheme.bgColorContainer,
              child: Center(child: Text('没有找到相关菜谱')),
            );
          }
        }
        return Container(
          color: colorScheme.bgColorContainer,
          child: Scrollbar(
            radius: const Radius.circular(4),
            child: GridView.builder(
              primary: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                var cookbook = cookbooks[index];
                var cookbookId = cookbook.cookbookId!;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (_isSelectMode) {
                        toggleSelect(cookbookId);
                      } else {
                        // 跳转到菜谱详情页
                        Navigator.restorablePushNamed(context, RouteQuery.cookbookPreview,
                            arguments: {'id': cookbookId});
                      }
                    },
                    onLongPress: () {
                      enableSelectMode(cookbookId);
                      Feedback.forLongPress(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Material(
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0.5,
                                  child: Image.file(
                                    File(cookbook.coverImagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          '封面加载失败',
                                          style: TextStyle(color: colorScheme.errorColor),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (_isSelectMode)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Checkbox(
                                    splashRadius: 0,
                                    value: _selectedId.contains(cookbookId),
                                    onChanged: (value) => toggleSelect(cookbookId),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            cookbook.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.textColorPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: itemCount,
              padding: const EdgeInsets.all(12),
            ),
          ),
        );
      },
      future: _future,
    );
  }

  /// 加载全部列表数据
  Future<List<Cookbook>> _loadAll() async {
    var text = _searchTextController.text.trim();
    var cookbooks = await cookbookDaoSupport.findAll(
      where: 'title like ?',
      whereArgs: ['%$text%'],
      orderBy: 'create_time desc',
    );
    if (kDebugMode) {
      Logger.root.fine(cookbooks);
    }
    return cookbooks;
  }

  /// 删除菜谱
  Future<void> deleteIds(List<int> ids) async {
    await cookbookDaoSupport.batchDeleteById(ids);
    await ImageFileUtil.deleteCookbookIds(ids);
  }

  void _loadData() {
    if (mounted) {
      setState(() {
        _future = _loadAll();
      });
    } else {
      _loadData();
    }
  }

  /// 新建菜谱
  void createCookbook() {
    showCameraAndGalleryBottomSheet(context, (image) async {
      // 获取文件扩展名
      var name = image.name.contains('.') ? '.${image.name.split('.').last}' : '';

      var tempPath = await ImageFileUtil.copyBytesToTempFile(await image.readAsBytes(), extension: name);

      Logger.root.info('临时文件：$tempPath');

      Navigator.restorablePushNamed(context, RouteQuery.cookbookEdit, arguments: {'path': tempPath});
    });
  }

  /// 启用选择模式
  void enableSelectMode([int? id]) {
    if (!_isSelectMode) {
      setState(() {
        _isSelectMode = true;
        if (id != null) {
          _selectedId.add(id);
        }
      });
    }
  }

  /// 退出选择模式
  void _closeSelect() {
    if (_isSelectMode) {
      setState(() {
        _selectedId.clear();
        _isSelectMode = false;
      });
    }
  }

  /// 全选/取消全选
  void toggleSelectAll() {
    if (_isSelectMode) {
      setState(() {
        if (_selectedId.length == itemCount) {
          _selectedId.clear();
        } else {
          _selectedId.addAll(cookbooks.map((e) => e.cookbookId!));
        }
      });
    }
  }

  /// 选择/取消选择
  void toggleSelect(int id) {
    if (_isSelectMode) {
      setState(() {
        if (_selectedId.contains(id)) {
          _selectedId.remove(id);
        } else {
          _selectedId.add(id);
          _isSelectMode = true;
        }
      });
    }
  }
}
