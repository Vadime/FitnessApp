import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final int markedIndex;
  final Function(int index)? onChange;

  final List<NavigationBarItem> items;

  const BottomNavigationBarWidget({
    required this.currentIndex,
    required this.items,
    this.markedIndex = 0,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
        //  Stack(
        //   children: [
        //     Align(
        //       alignment: Alignment(
        //         ((markedIndex) - 1).toDouble(),
        //         0,
        //       ),
        //       child: Container(
        //         height: 4,
        //         width: 4,
        //         decoration: BoxDecoration(
        //           color: context.theme.primaryColor,
        //           borderRadius: BorderRadius.circular(2),
        //         ),
        //       ),
        //     ),
        Padding(
      padding: EdgeInsets.only(
        left: context.leftInset + context.config.paddingD,
        bottom: context.mediaQuery.viewPadding.bottom + context.config.paddingH,
        right: context.rightInset + context.config.paddingD,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.config.radius),
        child: MediaQuery(
          data: context.mediaQuery.copyWith(
            padding: EdgeInsets.zero,
            viewInsets: EdgeInsets.zero,
            viewPadding: EdgeInsets.zero,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onChange,
            items: items
                .map((e) => BottomNavigationBarItem(
                      label: e.label,
                      icon: Icon(e.icon),
                    ))
                .toList(),
            selectedFontSize: 0,
            unselectedFontSize: 0,
          ),
        ),
      ),
    )
        //   ],
        // ),
        ;
  }
}
