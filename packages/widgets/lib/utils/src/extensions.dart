import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

extension WidgetBuildContextExtensions on BuildContext {
  /// get theme quickly
  ThemeData get theme => Theme.of(this);

  /// get textTheme quickly
  TextTheme get textTheme => theme.textTheme;

  /// get color scheme quickly
  ColorScheme get colorScheme => theme.colorScheme;

  /// get safeArea quickly
  EdgeInsets get safeArea => MediaQuery.of(this).padding;
  EdgeInsets get safeAreaLeftRight => MediaQuery.of(this).padding.copyWith(
        top: 0,
        bottom: 0,
      );

  /// get bottom inset quickly
  double get bottomInset => MediaQuery.of(this).padding.bottom;
  double get topInset => MediaQuery.of(this).padding.top;
  double get leftInset => MediaQuery.of(this).padding.left;
  double get rightInset => MediaQuery.of(this).padding.right;

  /// get mediaQuery quickly
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // get height - padding - bottomInset quickly
  double get heightWithoutSafeArea =>
      mediaQuery.size.height - safeArea.vertical;

  /// get theme config quickly
  ThemeConfig get config => BlocProvider.of<ThemeController>(this).config;

  /// get brightness quickly
  Brightness get brightness => theme.brightness;
}

extension WidgetTextEditingControllerExtensions on TextEditingController {
  /// set text and set selection to the end of the text
  set textToEnd(String text) {
    this.text = text;
    selectionToEnd();
  }

  /// set selecion to the end of the text
  void selectionToEnd() => selection = TextSelection.fromPosition(
      TextPosition(offset: text.length, affinity: TextAffinity.upstream));
}

extension PageControllerExtension on PageController {
  void go(int page) => animateToPage(
        page,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
      );

  // get current page
  int get currentPage => hasClients ? (page?.round() ?? 0) : 0;
}

extension StringExtension on String? {
  DateTime get dateTime {
    if (this == null || this == '') return DateTime.now();
    var arr = this!.split('.');
    return DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
  }

  String get intFormat => (this == null || this == '') ? '0' : this!;
}

extension DateTimeExtension on DateTime {
  String get str =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString().padLeft(4, '0')}';
  String get strNotYear =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}';
}

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets safe(BuildContext context) => EdgeInsets.only(
        left: left + context.safeArea.left,
        right: right + context.safeArea.right,
        top: top + context.safeArea.top,
        bottom: bottom + context.safeArea.bottom,
      );
}
