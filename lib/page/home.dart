import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_meal/components/app_bar_input.dart';
import 'package:my_meal/icons/t_icons.dart';
import 'package:my_meal/theme/theme.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white.withAlpha(120),
        leadingWidth: 40,
        titleSpacing: 0,
        // 中间的搜索框
        title: AppBarInput(),
        // 左侧菜单按钮
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            iconSize: 16,
            icon: Icon(
              TIcons.view_list,
            ),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          );
        }),
        // actions: [TextButton(onPressed: () {}, child: Text('data'))],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var colorScheme = TTheme.of(context).colorScheme;
    return Container(
      color: Colors.white,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://i2.chuimg.com/12893569b3c346f49a6b682484f0c3dc_1242w_1656h.jpg?imageView2/2/w/660/interlace/1/q/75",
                      fit: BoxFit.cover,
                    ),
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
          itemCount: 10,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
