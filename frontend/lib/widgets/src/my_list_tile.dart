import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  final Color? tileColor;
  final bool selected;
  final Color? selectedTileColor;

  const MyListTile({
    Key? key,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 0),
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ListTile(
        onTap: onTap,
        selected: selected,
        selectedTileColor: selectedTileColor,
        contentPadding: padding,
        tileColor: tileColor,
        title: title == null ? null : Text(title!),
        subtitle: subtitle == null ? null : Text(subtitle!),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
