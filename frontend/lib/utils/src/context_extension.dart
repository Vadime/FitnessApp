library utils;

import 'package:flutter/material.dart';

extension AppExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  double get shortestSide => MediaQuery.of(this).size.shortestSide;

  // get bottom inset
  double get bottomInset => MediaQuery.of(this).viewPadding.bottom;

  double get topInset => MediaQuery.of(this).viewPadding.top;
}
