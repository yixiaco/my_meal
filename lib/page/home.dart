import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:my_meal/components/app_bar_input.dart';
import 'package:my_meal/components/camera_and_gallery_bottom_sheet.dart';
import 'package:my_meal/dao/cookbook_dao.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/model/cookbook.dart';
import 'package:my_meal/route.dart';
import 'package:my_meal/theme/color_scheme.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';
import 'package:my_meal/database/support.dart' as support;
import 'package:my_meal/util/debounced.dart';

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

  /// 列表分页数据
  support.Page<Cookbook>? page;

  /// 列表数据
  List<Cookbook> cookbooks = [];

  /// 列表控制器
  late EasyRefreshController _easyRefreshController;

  /// 搜索框输入框改变防抖事件
  final debounced = Debounced(milliseconds: 300);

  @override
  void initState() {
    _searchTextController = TextEditingController();
    _easyRefreshController = EasyRefreshController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
    _searchTextController.dispose();
    debounced.dispose();
  }

  int get itemCount {
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = TTheme.of(context);
    var colorScheme = themeData.colorScheme;
    return PopScope(
      canPop: !_isSelectMode,
      onPopInvokedWithResult: (didPop, result) {
        // 当发生了返回事件时，关闭选择模式
        closeSelect();
      },
      child: Scaffold(
        appBar: _buildArrBar(context, themeData),
        body: _buildBody(context, colorScheme),
        floatingActionButton: _buildFloatingActionButton(colorScheme),
      ),
    );
  }

  /// 构建浮动删除按钮
  Widget? _buildFloatingActionButton(TColorScheme colorScheme) {
    return _isSelectMode && _selectedId.isNotEmpty
        ? FloatingActionButton(
            onPressed: () {
              // todo: 删除逻辑
            },
            mini: true,
            backgroundColor: colorScheme.errorColor,
            child: Icon(TIcons.delete, size: 16),
          )
        : null;
  }

  /// 构建appbar
  PreferredSizeWidget _buildArrBar(BuildContext context, TThemeData themeData) {
    Widget iconButton;
    Widget leading;
    Widget title;
    if (_isSelectMode) {
      // 选择模式下，显示全选按钮
      iconButton = IconButton(
        onPressed: toggleSelectAll,
        icon: Icon(
          _selectedId.length == itemCount ? Icons.add_box_rounded : Icons.add_box_outlined,
        ),
      );
      leading = IconButton(onPressed: closeSelect, icon: Icon(Icons.close_rounded));
      title = Text('已选择${_selectedId.length}项', style: TextStyle(fontSize: themeData.fontData.fontSizeTitleMedium));
    } else {
      iconButton = GestureDetector(
        onTap: () {
          showCameraAndGalleryBottomSheet(context, (image) {
            Navigator.restorablePushNamed(context, RouteQuery.cookbookEdit, arguments: {'path': image.path});
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Icon(Icons.add_circle_outline_rounded),
        ),
      );
      leading = Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu_rounded),
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
        );
      });
      title = AppBarInput(
        controller: _searchTextController,
        onChanged: (value) {
          debounced.run(() {
            _refresh();
            // _easyRefreshController.callRefresh(
            //   duration: null,
            // );
            _easyRefreshController.resetHeader();
            _easyRefreshController.resetFooter();
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
      actions: [iconButton],
    );
  }

  /// 构建body
  Widget _buildBody(BuildContext context, TColorScheme colorScheme) {
    return EasyRefresh(
      controller: _easyRefreshController,
      header: const ClassicHeader(
        dragText: '下拉刷新',
        armedText: '释放开始',
        readyText: '刷新中...',
        processingText: '刷新中...',
        processedText: '刷新完成',
        noMoreText: '没有更多数据',
        failedText: '失败',
        messageText: '最后更新于 %T',
      ),
      footer: ClassicFooter(
        dragText: '上拉加载',
        armedText: '释放开始',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载完成',
        noMoreText: '没有更多数据',
        failedText: '失败',
        messageText: '最后更新于 %T',
        processedDuration: Duration(seconds: 1),
      ),
      refreshOnStart: true,
      onRefresh: _refresh,
      onLoad: _loadMore,
      child: Container(
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => toggleSelect(index),
                              onLongPress: () => enableSelectMode(index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "https://i2.chuimg.com/161db4602103468d8d2fc44b77044af4_1000w_1500h.jpg?imageView2/1/w/640/h/520/q/75/format/jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_isSelectMode)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Checkbox(
                              splashRadius: 0,
                              value: _selectedId.contains(index),
                              onChanged: (value) => toggleSelect(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "鲜掉眉毛！咸蛋黄鲜虾豆腐｜天冷煮一锅，暖胃又舒心",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.textColorPrimary),
                    ),
                  )
                ],
              );
            },
            itemCount: itemCount,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }

  /// 刷新列表数据
  Future<void> _refresh() async {
    var text = _searchTextController.text.trim();
    page = await cookbookDaoSupport.findPage(
      where: 'title like ?',
      whereArgs: ['%$text%'],
      orderBy: 'create_time desc',
    );
    cookbooks = page!.data;
    Logger.root.fine(page!.data);
  }

  /// 加载更多数据
  Future<IndicatorResult> _loadMore() async {
    if (page != null && page!.isLast) {
      return IndicatorResult.noMore;
    }
    var text = _searchTextController.text.trim();
    page = await cookbookDaoSupport.findPage(
      where: 'title like ?',
      page: page?.pageNo ?? 0 + 1,
      whereArgs: ['%$text%'],
      orderBy: 'create_time desc',
    );
    Logger.root.fine(page!.data);
    cookbooks.addAll(page!.data);
    if (page!.isLast) {
      return IndicatorResult.noMore;
    }
    return IndicatorResult.success;
  }

  /// 启用选择模式
  void enableSelectMode([int? index]) {
    if (!_isSelectMode) {
      setState(() {
        _isSelectMode = true;
        if (index != null) {
          _selectedId.add(index);
        }
      });
    }
  }

  /// 退出选择模式
  void closeSelect() {
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
          _selectedId.addAll(List.generate(itemCount, (index) => index));
        }
      });
    }
  }

  /// 选择/取消选择
  void toggleSelect(int index) {
    if (_isSelectMode) {
      setState(() {
        if (_selectedId.contains(index)) {
          _selectedId.remove(index);
        } else {
          _selectedId.add(index);
          _isSelectMode = true;
        }
      });
    }
  }
}
