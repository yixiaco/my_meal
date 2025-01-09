import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/components/app_bar_input.dart';
import 'package:my_meal/components/camera_and_gallery_bottom_sheet.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/theme/color_scheme.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Set<int> _selectedIndex = {};
  bool _isSelectMode = false;

  int get itemCount {
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = TTheme.of(context);
    var colorScheme = themeData.colorScheme;
    return Scaffold(
      appBar: _buildArrBar(context, themeData),
      body: _buildBody(context, colorScheme),
      floatingActionButton: _buildFloatingActionButton(colorScheme),
    );
  }

  /// 构建浮动删除按钮
  Widget? _buildFloatingActionButton(TColorScheme colorScheme) {
    return _isSelectMode && _selectedIndex.isNotEmpty
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
          _selectedIndex.length == itemCount ? Icons.add_box_rounded : Icons.add_box_outlined,
        ),
      );
      leading = IconButton(onPressed: closeSelect, icon: Icon(Icons.close_rounded));
      title = Text('已选择${_selectedIndex.length}项', style: TextStyle(fontSize: themeData.fontData.fontSizeTitleMedium));
    } else {
      iconButton = GestureDetector(
        onTap: () => showCameraAndGalleryBottomSheet(context),
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
      title = AppBarInput();
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
                                "https://i2.chuimg.com/12893569b3c346f49a6b682484f0c3dc_1242w_1656h.jpg?imageView2/2/w/660/interlace/1/q/75",
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
                            value: _selectedIndex.contains(index),
                            onChanged: (value) => toggleSelect(index),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "红烧里脊",
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
    );
  }

  /// 启用选择模式
  void enableSelectMode([int? index]) {
    if (!_isSelectMode) {
      setState(() {
        _isSelectMode = true;
        if (index != null) {
          _selectedIndex.add(index);
        }
      });
    }
  }

  /// 退出选择模式
  void closeSelect() {
    if (_isSelectMode) {
      setState(() {
        _selectedIndex.clear();
        _isSelectMode = false;
      });
    }
  }

  /// 全选/取消全选
  void toggleSelectAll() {
    if (_isSelectMode) {
      setState(() {
        if (_selectedIndex.length == itemCount) {
          _selectedIndex.clear();
        } else {
          _selectedIndex.addAll(List.generate(itemCount, (index) => index));
        }
      });
    }
  }

  /// 选择/取消选择
  void toggleSelect(int index) {
    if (_isSelectMode) {
      setState(() {
        if (_selectedIndex.contains(index)) {
          _selectedIndex.remove(index);
        } else {
          _selectedIndex.add(index);
          _isSelectMode = true;
        }
      });
    }
  }
}
