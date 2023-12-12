import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

double barHeights(BuildContext context) =>
    kToolbarHeight + context.config.paddingH;

double appBarHeight(BuildContext context) => kToolbarHeight;

class ScaffoldWidget extends StatelessWidget {
  final String? title;
  final void Function()? onTitleTap;
  final List<Widget>? actions;
  final Widget body;
  final NavigationBarData? navigationBarData;

  final bool looseFocusOnTap;
  final Color? backgroundColor;
  final Widget drawerHeader;
  final List<Widget>? drawerItems;
  final Widget? primaryButton;

  const ScaffoldWidget({
    this.title,
    this.onTitleTap,
    this.actions,
    this.body = const SizedBox.shrink(),
    this.navigationBarData,
    this.drawerItems,
    this.looseFocusOnTap = false,
    this.drawerHeader = const SizedBox.shrink(),
    this.backgroundColor,
    this.primaryButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        //onTap: looseFocusOnTap ? () => Focus.of(context).unfocus() : null,
        onVerticalDragEnd: (details) {
          double swipeVelocityThreshold =
              2000; // Adjust this threshold as needed

          if (details.velocity.pixelsPerSecond.dy > swipeVelocityThreshold) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: LayoutBuilder(builder: (context, constraints) {
          bool portrait = constraints.maxWidth < constraints.maxHeight;
          if (portrait) {
            switch (ThemeConfig.screenSize(context)) {
              case ScreenSize.small:
                return ScaffoldSmallPortrait(
                  title: title,
                  onTitleTap: onTitleTap,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  drawerItems: drawerItems,
                  navigationBarData: navigationBarData,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              case ScreenSize.medium:
                return ScaffoldSmallPortrait(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  drawerItems: drawerItems,
                  navigationBarData: navigationBarData,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              case ScreenSize.large:
                return ScaffoldSmallPortrait(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerItems: drawerItems,
                  drawerHeader: drawerHeader,
                  navigationBarData: navigationBarData,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              default:
                return ScaffoldSmallPortrait(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  navigationBarData: navigationBarData,
                  drawerItems: drawerItems,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
            }
          } else {
            switch (ThemeConfig.screenSize(context)) {
              case ScreenSize.small:
                return ScaffoldSmallLandscape(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  navigationBarData: navigationBarData,
                  drawerItems: drawerItems,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              case ScreenSize.medium:
                return ScaffoldLargeLandscape(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  drawerItems: drawerItems,
                  navigationBarData: navigationBarData,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              case ScreenSize.large:
                return ScaffoldLargeLandscape(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  drawerItems: drawerItems,
                  navigationBarData: navigationBarData,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
              default:
                return ScaffoldSmallLandscape(
                  title: title,
                  actions: actions,
                  body: body,
                  drawerHeader: drawerHeader,
                  navigationBarData: navigationBarData,
                  drawerItems: drawerItems,
                  looseFocusOnTap: looseFocusOnTap,
                  backgroundColor: backgroundColor,
                  primaryButton: primaryButton,
                );
            }
          }
        }),
      );
}
