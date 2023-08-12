import 'package:flutter/material.dart';

extension on BuildContext {
  double get topInset => MediaQuery.of(this).padding.top;
  // half of screen
  double get halfWidth => MediaQuery.of(this).size.width / 2;
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final List<Widget>? actions;
  const MyAppBar({
    super.key,
    this.leading,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        top: context.topInset,
        right: 30,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MediaQuery(
          data: const MediaQueryData(
            padding: EdgeInsets.zero,
          ),
          child: Hero(
            tag: 'title',
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: Container(
                height: kToolbarHeight,
                width: kToolbarHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                ),
                child: leading ??
                    IconButton(
                      icon: Icon(Icons.adaptive.arrow_back_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
              ),
              title: Container(
                width: context.halfWidth,
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: FittedBox(child: Text(title)),
              ),
              actions: actions == null
                  ? null
                  : [
                      Container(
                        height: kToolbarHeight,
                        width: kToolbarHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: actions!,
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
