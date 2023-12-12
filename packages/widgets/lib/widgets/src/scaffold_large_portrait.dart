import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ScaffoldLargePortrait extends StatelessWidget {
  final String? title;
  final void Function()? onTitleTap;
  final Widget drawerHeader;
  final List<Widget>? actions;
  final Widget body;
  final NavigationBarData? navigationBarData;
  final bool looseFocusOnTap;
  final Color? backgroundColor;
  final List<Widget>? drawerItems;
  final Widget? primaryButton;

  const ScaffoldLargePortrait({
    this.title,
    this.actions,
    this.onTitleTap,
    this.drawerHeader = const SizedBox.shrink(),
    this.body = const SizedBox.shrink(),
    this.navigationBarData,
    this.drawerItems,
    this.looseFocusOnTap = false,
    this.backgroundColor,
    this.primaryButton,
    super.key,
  });

  get hasNav => navigationBarData != null;
  get hasAppBar => title != null;
  get hasAppBarActions => actions != null && actions!.isNotEmpty;
  get hasDrawer =>
      drawerItems != null || (navigationBarData?.items.length ?? 0) > 5;
  get hasFloatingActions => actions != null && actions!.length > 1;
  get hasPrimaryButton => primaryButton != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: portraitAppBar(context),
      drawer: drawer(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MediaQuery(
              data: context.mediaQuery.copyWith(
                padding: EdgeInsets.fromLTRB(
                  context.leftInset,
                  (hasAppBar ? appBarHeight(context) : 0) + context.topInset,
                  context.rightInset,
                  (hasNav ? barHeights(context) : 0) + context.bottomInset,
                ),
              ),
              child: body),
          Positioned(
            bottom: context.bottomInset +
                (hasNav ? barHeights(context) : 0) +
                context.config.paddingH,
            left: 40,
            right: 40,
            child: floatingActions(context),
          ),
        ],
      ),
      bottomNavigationBar: bottom(context),
    );
  }

  Drawer? drawer(BuildContext context) => hasDrawer
      ? Drawer(
          child: DrawerWidget(
          drawerHeader: drawerHeader,
          drawerItems: drawerItems,
          showNavigation: hasNav,
          navigationBarData: navigationBarData,
        ))
      : null;

  AppBarWidget? portraitAppBar(BuildContext context) => hasAppBar
      ? AppBarWidget(
          title!,
          onTitleTap: onTitleTap,
          actions: [if (hasAppBarActions) actions!.first],
        )
      : null;

  Widget floatingActions(BuildContext context) => FloatingAtionsWidget(
        actions: actions?.getRange(1, actions!.length).toList(),
        primaryButton: primaryButton,
      );

  Widget? bottom(BuildContext context) => hasNav
      ? BottomNavigationBarWidget(
          currentIndex: navigationBarData!.currentIndex,
          items: navigationBarData!.items
              .getRange(0, min(navigationBarData!.items.length, 5))
              .toList(),
          onChange: navigationBarData!.onChange,
        )
      : null;
}
