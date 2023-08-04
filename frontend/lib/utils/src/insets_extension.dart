library utils;

import 'package:flutter/material.dart';

extension AddSafeArea on EdgeInsets {
  EdgeInsets addSafeArea(context) {
    var p = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: top + p.top,
      bottom: bottom + p.bottom,
      left: left + p.left,
      right: right + p.right,
    );
  }
}
