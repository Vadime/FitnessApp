import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SideNavigationWidget extends StatelessWidget {
  final int currentIndex;

  final Function(int index)? onChange;

  final List<NavigationBarItem> items;

  const SideNavigationWidget({
    required this.currentIndex,
    required this.items,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kToolbarHeight,
      decoration: BoxDecoration(
        color: context.config
            .cardColor(context.brightness)
            .withOpacity(context.config.opacity),
        borderRadius: BorderRadius.circular(context.config.radius),
      ),
      child: SingleChildScrollView(
        child: ColumnWidget(
            margin: EdgeInsets.fromLTRB(
              0, // context.config.paddingH,
              context.config.paddingH,
              0, // context.config.paddingH,
              context.config.paddingH,
            ),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < items.length; i++)
                IconButtonWidget(
                  items[i].icon,
                  onPressed: () {
                    onChange?.call(i);
                  },
                  margin: EdgeInsets.zero,
                  foregroundColor:
                      currentIndex == i ? context.config.primaryColor : null,
                ),
            ]),
      ),
    );
  }
}
