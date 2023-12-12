import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class DrawerWidget extends StatelessWidget {
  final Widget drawerHeader;
  final List<Widget>? drawerItems;
  final bool showNavigation;
  final NavigationBarData? navigationBarData;

  const DrawerWidget({
    required this.drawerItems,
    required this.drawerHeader,
    required this.showNavigation,
    required this.navigationBarData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.config
          .backgroundColor(context.brightness)
          .withOpacity(context.config.opacity),
      child: SingleChildScrollView(
        child: SafeArea(
          right: false,
          child: ColumnWidget(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              drawerHeader,
              if (showNavigation)
                for (int i = 0; i < navigationBarData!.items.length; i++)
                  ListTileWidget(
                    leading: Icon(navigationBarData!.items[i].icon,
                        color: navigationBarData!.currentIndex == i
                            ? context.config.primaryColor
                            : context.config
                                .textColor(context.brightness)
                                .withOpacity(0.6)),
                    title: navigationBarData!.items[i].label,
                    foregroundColor: navigationBarData!.currentIndex == i
                        ? context.config.primaryColor
                        : context.config
                            .textColor(context.brightness)
                            .withOpacity(0.6),
                    onTap: () => navigationBarData!.onChange?.call(i),
                  ),
              const SizedBox(height: 20),
              if (drawerItems != null) ...drawerItems!,
            ],
          ),
        ),
      ),
    );
  }
}
