import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final void Function()? onTitleTap;
  final List<Widget>? actions;
  final EdgeInsets? margin;

  const AppBarWidget(
    this.title, {
    this.onTitleTap,
    super.key,
    this.leading,
    this.margin,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          EdgeInsets.only(
            left: context.leftInset + context.config.paddingD,
            top: context.topInset + context.config.paddingH,
            right: context.rightInset + context.config.paddingD,
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.config.radius),
        child: MediaQuery(
          data: context.mediaQuery.copyWith(
            padding: EdgeInsets.zero,
          ),
          child: AppBar(
            leading: leading,
            surfaceTintColor: Colors.transparent,
            title: GestureDetector(
                onTap: onTitleTap,
                child: TextWidget(
                  title,
                  color:
                      onTitleTap == null ? null : context.config.primaryColor,
                  align: TextAlign.center,
                )),
            actions: actions,
            toolbarHeight: preferredSize.height - 10,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
