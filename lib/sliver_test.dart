import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SliverTest extends StatefulWidget {
  SliverTest({Key? key}) : super(key: key);

  @override
  State<SliverTest> createState() => _SliverTestState();
}

class _SliverTestState extends State<SliverTest>
    with SingleTickerProviderStateMixin {
  RefreshController controller = RefreshController();

  List<int> items = List.generate(20, (index) => index);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    controller.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1));
    if (mounted) {
      setState(() {});
    }
    controller.loadComplete();
  }

  final tabs = [
    Tab(
      text: '窝的收益',
    ),
    Tab(
      text: '窝的奖励',
    )
  ];

  late final firstTabController =
      TabController(length: tabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SmartRefresher(
          key: ObjectKey(controller),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullUp: true,
          controller: controller,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('sliver test'),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200.w,
                  color: Colors.blueGrey,
                ),
              ),
              SliverPersistentHeader(delegate: FirstTabView(tabs, controller)),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.blue[200 + items[index] % 4 * 100],
                    height: 100 + items[index] % 4 * 20.0,
                    child: Text('Item: ${items[index]}'),
                  );
                },
                childCount: items.length,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstTabView extends SliverPersistentHeaderDelegate {
  FirstTabView(this.tabs, this.controller);

  final List<Tab> tabs;
  final TabController controller;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TabBar(
      tabs: tabs,
      controller: controller,
    );
  }

  @override
  double get maxExtent => 30.w;

  @override
  double get minExtent => 30.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return this==oldDelegate;
  }
}
