import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SliverTest extends StatefulWidget {
  SliverTest({Key? key}) : super(key: key);

  @override
  State<SliverTest> createState() => _SliverTestState();
}

class _SliverTestState extends State<SliverTest> {
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
                pinned: true,
                expandedHeight: 400,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30),
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.amberAccent,
                    alignment: Alignment.center,
                    child: Text('哈哈'),
                  ),
                ),
              ),
              SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.blue[200 + items[index] % 4 * 100],
                  height: 100 + items[index] % 4 * 20.0,
                  child: Text('Item: ${items[index]}'),
                );
              }))
            ],
          ),
        ),
      ),
    );
  }
}
