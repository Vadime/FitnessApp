import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ScaffoldSmallLandscape extends StatelessWidget {
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

  const ScaffoldSmallLandscape({
    this.title,
    this.onTitleTap,
    this.actions,
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
  get hasFloatingActions => actions != null && actions!.isNotEmpty;
  get hasPrimaryButton => primaryButton != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: landscapeAppBar(context),
      drawer: drawer(context),
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: MediaQuery(
              data: context.mediaQuery.copyWith(
                padding: EdgeInsets.only(
                  top: (hasAppBar ? appBarHeight(context) : 0) +
                      context.topInset,
                  bottom: context.bottomInset + (hasPrimaryButton ? 56 : 0),
                  right: context.rightInset,
                  left: (hasNav ? barHeights(context) : 0) + context.leftInset,
                ),
              ),
              child: body,
            ),
          ),
          if (side != null)
            Positioned(
              left: context.leftInset + context.config.paddingH,
              top: context.topInset +
                  appBarHeight(context) +
                  context.config.paddingH,
              bottom: context.bottomInset + context.config.paddingH,
              child: side!,
            ),
          Positioned(
            bottom: context.bottomInset + context.config.paddingH,
            left: context.leftInset + 40,
            right: context.rightInset + 40,
            child: floatingActions(context),
          ),
        ],
      ),
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

  AppBarWidget? landscapeAppBar(BuildContext context) => hasAppBar
      ? AppBarWidget(
          title!,
          onTitleTap: onTitleTap,
          actions: [if (hasAppBarActions) actions!.first],
          margin: EdgeInsets.only(
            left: context.leftInset + context.config.paddingH,
            top: context.topInset + context.config.paddingH,
            right: context.rightInset + context.config.paddingH,
          ),
        )
      : null;

  Widget floatingActions(BuildContext context) => FloatingAtionsWidget(
        actions: actions,
        primaryButton: primaryButton,
      );

  SideNavigationWidget? get side => hasNav
      ? SideNavigationWidget(
          currentIndex: navigationBarData!.currentIndex,
          items: navigationBarData!.items,
          onChange: navigationBarData!.onChange,
        )
      : null;
}
