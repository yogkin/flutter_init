import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:easy_refresh_my/easy_refresh_skating.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'custom_tab_indicator.dart';

class SliverTabBarViewPage extends StatefulWidget {
  const SliverTabBarViewPage({Key? key}) : super(key: key);

  @override
  SliverTabBarViewPageState createState() {
    return SliverTabBarViewPageState();
  }
}

class SliverTabBarViewPageState extends State<SliverTabBarViewPage>
    with TickerProviderStateMixin {
  late TabController firstTabController =
      TabController(length: firstTabs.length, vsync: this)
        ..addListener(() {
          if (!firstTabController.indexIsChanging) {
            log("监听切换tab ${firstTabController.index} ");
            setState(() {
              isShowSecondTab = firstTabController.index == 1;
              isShowThreeTab = true;
              childFirstTabController.animateTo(firstTabController.index);
            });
          }
        });

  late TabController childSecondTabController = TabController(
      length: secondTabs.length, vsync: this)
    ..addListener(() {
      if (!childSecondTabController.indexIsChanging) {
        log("监听切换tab ${childSecondTabController.index} ");
        setState(() {
          isShowThreeTab = childSecondTabController.index == 0;
          childFirstTabController.animateTo(
              firstTabController.index + childSecondTabController.index + 1);
        });
      }
    });

  late TabController childThreeTabController =
      TabController(length: threeTabs.length, vsync: this)
        ..addListener(() {
          if (!childThreeTabController.indexIsChanging) {
            log("监听切换tab ${childThreeTabController.index} ");
            setState(() {
              isShowThreeTab = childSecondTabController.index == 0;
              childFirstTabController.animateTo(firstTabController.index +
                  childSecondTabController.index +
                  childThreeTabController.index +
                  2);
            });
          }
        });

  late TabController childFirstTabController =
      TabController(length: allTabLength, vsync: this);

  @override
  void dispose() {
    super.dispose();
    firstTabController.dispose();
    childThreeTabController.dispose();
    childFirstTabController.dispose();
  }

  late final allTabLength =
      firstTabs.length + secondTabs.length + threeTabs.length;

  final threeTabs = const [
    Tab(
      text: '今日',
    ),
    Tab(
      text: '昨天',
    ),
    Tab(
      text: '本月',
    ),
    Tab(
      text: '上月',
    )
  ];
  final secondTabs = const [
    Tab(
      text: '任务值明细',
    ),
    Tab(
      text: '活动奖励',
    )
  ];

  final firstTabs = const [
    Tab(
      text: '我的收益',
    ),
    Tab(
      text: '我的奖励',
    )
  ];

  List<int> items = List.generate(20, (index) => index);

  bool isShowSecondTab = false;
  bool isShowThreeTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EasyRefresh.builder(
            header: const SkatingHeader(
                position: IndicatorPosition.locator,
                triggerOffset: 100,
                clamping: true),
            footer: ClassicFooter(
              position: IndicatorPosition.locator,
              dragText: 'Pull to load'.tr,
              armedText: 'Release ready'.tr,
              readyText: 'Loading...'.tr,
              processingText: 'Loading...'.tr,
              processedText: 'Succeeded'.tr,
              noMoreText: 'No more'.tr,
              failedText: 'Failed'.tr,
              messageText: 'Last updated at %T'.tr,
            ),
            onRefresh: () async {},
            childBuilder: (context, physics) {
              return ExtendedNestedScrollView(
                physics: physics,
                onlyOneScrollInBody: true,
                pinnedHeaderSliverHeightBuilder: () {
                  return MediaQuery.of(context).padding.top + kToolbarHeight;
                },
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    const HeaderLocator.sliver(clearExtent: false),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color(0xFFFFFA5D),
                                  Color(0xFFF9F8ED)
                                ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            height: 238.w,
                          ),
                          Container(
                            height: 145.w,
                            margin: EdgeInsets.only(top: 93.w),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage('assets/images/icon_top_bg.png'),
                            )),
                          ),
                          Column(
                            children: [
                              AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                leading: const SizedBox.shrink(),
                                centerTitle: true,
                                foregroundColor: Colors.black,
                                title: Text(
                                  '我的帐户',
                                  style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 18.sp),
                                ),
                              ),
                              Container(
                                height: 45.w,
                                margin: EdgeInsets.symmetric(horizontal: 27.w),
                                padding: EdgeInsets.only(left: 18.w),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF3D3D47),
                                          Color(0xFF555563)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.w))),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  '账户总余额 ￥880,000.26',
                                  style: TextStyle(color: Color(0xFFECECEC)),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                              top: 69.w,
                              right: 40.w,
                              child: Image.asset(
                                'assets/images/icon_mz.png',
                                width: 52.w,
                              )),
                        ],
                      ),
                    ),
                    SliverLayoutBuilder(
                      builder: (BuildContext context,
                          SliverConstraints constraints) {
                        return SliverPersistentHeader(
                          delegate: FirstTabView(
                              firstTabs, firstTabController, constraints),
                          pinned: true,
                        );
                      },
                    ),
                    SliverVisibility(
                        visible: isShowSecondTab,
                        sliver: SliverPersistentHeader(
                          delegate: SecondTabView(
                              secondTabs, childSecondTabController),
                          pinned: true,
                        )),
                    SliverVisibility(
                        visible: isShowThreeTab,
                        sliver: SliverPersistentHeader(
                          delegate:
                              SecondTabView(threeTabs, childThreeTabController),
                          pinned: true,
                        ))
                  ];
                },
                body: TabBarView(
                  controller: childFirstTabController,
                  children: List.generate(
                    allTabLength,
                    (index) => ExtendedVisibilityDetector(
                      uniqueKey: Key('Tab$index'),
                      child: _AutomaticKeepAlive(
                        child: CustomScrollView(
                          physics: physics,
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                color:
                                    Colors.blue[200 + items[index] % 4 * 100],
                                height: 100 + items[index] % 4 * 20.0,
                                child: Text('Item: ${items[index]}'),
                              );
                            }, childCount: items.length)),
                            const FooterLocator.sliver(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
              top: 27.w,
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                    padding: EdgeInsets.all(15.w),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
              ))
        ],
      ),
    );
  }
}

class FirstTabView extends SliverPersistentHeaderDelegate {
  FirstTabView(this.tabs, this.controller, this.constraints);

  final List<Widget> tabs;
  final TabController controller;
  final SliverConstraints constraints;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    log("constraints build:${constraints.scrollOffset}");
    return Column(
      children: [
        Container(
          height: 31.w,
          margin: EdgeInsets.only(top: 6.w),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F8ED), Color(0xFFF8F8F8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Opacity(
            opacity: 1-constraints.scrollOffset/25,
            child: Text(
              '每月25-31号可提现上月结算收益',
              style:
                  TextStyle(color: const Color(0xFF986323), fontSize: 12.spMax),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 88.w, right: 88.w),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              height: 30.w,
              child: TabBar(
                tabs: tabs,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    TextStyle(fontSize: 15.sp, color: const Color(0xFF3D3D47)),
                labelColor: const Color(0xFF3D3D47),
                unselectedLabelStyle:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF6A6A70)),
                indicator: CustomTabIndicator(
                    insets:
                        EdgeInsets.symmetric(vertical: 3.w, horizontal: 4.w),
                    borderSide: BorderSide(width: 24.w, color: Colors.amber)),
                controller: controller,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 78.5.w;

  @override
  double get minExtent => 15.w + kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return this == oldDelegate;
  }
}

class SecondTabView extends SliverPersistentHeaderDelegate {
  SecondTabView(this.tabs, this.controller);

  final List<Widget> tabs;
  final TabController? controller;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: TabBar(
        tabs: tabs,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 15.sp, color: const Color(0xFF3D3D47)),
        labelColor: const Color(0xFF3D3D47),
        unselectedLabelStyle:
            TextStyle(fontSize: 14.sp, color: const Color(0xFF6A6A70)),
        indicator: CustomTabIndicator(
            insets: EdgeInsets.symmetric(vertical: 3.w, horizontal: 8.w),
            borderSide: BorderSide(width: 2.w, color: Colors.amber)),
        controller: controller,
      ),
    );
  }

  @override
  double get maxExtent => 30.w;

  @override
  double get minExtent => 30.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return this == oldDelegate;
  }
}

class _AutomaticKeepAlive extends StatefulWidget {
  final Widget child;

  const _AutomaticKeepAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<_AutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<_AutomaticKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
