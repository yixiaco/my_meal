import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/theme/theme.dart';
import 'package:my_meal/theme/theme_data.dart';

class CookbookReorder<T> extends StatefulHookConsumerWidget {
  const CookbookReorder({
    super.key,
    this.title,
    required this.list,
    required this.itemBuilder,
    this.onComplete,
  });

  final String? title;

  final List<T> list;

  final Widget Function(BuildContext context, T t, int index) itemBuilder;

  final void Function(List<T> list)? onComplete;

  @override
  ConsumerState<CookbookReorder<T>> createState() => _CookbookReorderState<T>();
}

class _CookbookReorderState<T> extends ConsumerState<CookbookReorder<T>> {
  late List<T> _list;

  @override
  void initState() {
    super.initState();
    _list = widget.list.toList();
  }

  @override
  void didUpdateWidget(covariant CookbookReorder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _list = widget.list.toList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = TTheme.of(context);
    var colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.bgColorContainer,
      appBar: _buildAppBar(theme),
      body: ReorderableListView.builder(
        padding: EdgeInsets.all(10),
        onReorder: _handleReorder,
        itemExtent: 50,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(theme, _list[index], index);
        },
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
        icon: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: widget.title != null ? Text(widget.title!, style: theme.fontData.fontTitleMedium) : null,
      centerTitle: true,
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.bgColorSecondaryContainer,
            overlayColor: colorScheme.bgColorSecondaryContainerActive,
          ),
          onPressed: _complete,
          child: Text('完成', style: TextStyle(color: colorScheme.textColorPrimary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _handleReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    setState(() {
      final element = _list.removeAt(oldIndex);
      _list.insert(newIndex, element);
    });
  }

  /// 完成
  void _complete() {
    widget.onComplete?.call(_list);
    Navigator.maybePop(context, _list);
  }

  Widget _buildItem(TThemeData theme, T t, int index) {
    var colorScheme = theme.colorScheme;
    return Container(
      key: ObjectKey(t),
      padding: EdgeInsets.only(right: 40),
      alignment: Alignment.centerLeft,
      child: Row(
        spacing: 8,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _list.remove(t);
                });
              },
              child: Icon(Icons.remove_circle, color: colorScheme.errorColor),
            ),
          ),
          Expanded(child: widget.itemBuilder(context, t, index)),
        ],
      ),
    );
  }
}
