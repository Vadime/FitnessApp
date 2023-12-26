import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:widgets/widgets.dart';

class Navigation {
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext get context => key.currentContext!;

  static NavigatorState get navigator => key.currentState!;

  static MaterialPageRoute standardRoute(Widget widget) {
    LoadingController().enableInput();
    return MaterialPageRoute(builder: (context) => widget);
  }

  static Future<void> push({required Widget widget}) async =>
      await navigator.push(standardRoute(widget));

  static Future<void> pushPopup({
    required Widget widget,
    BuildContext? c,
    bool dismissible = true,
  }) async {
    return await showModalBottomSheet(
        context: c ?? context,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        isDismissible: dismissible,
        isScrollControlled: true,
        enableDrag: false,
        barrierColor: (c ?? context).brightness == Brightness.light
            ? Colors.black38
            : Colors.white38,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(context.config.radius),
              ),
              padding: EdgeInsets.all(context.config.padding),
              margin: EdgeInsets.fromLTRB(
                // left
                context.config.paddingH,
                // top

                context.topInset + context.config.paddingH,
                // right
                context.config.paddingH,
                // bottom
                context.bottomInset + context.config.paddingH,
              ),
              child: widget,
            ));
  }

  static void pushDatePicker({
    DateTime? initial,
    required DateTime? first,
    required DateTime? last,
    Function(DateTime)? onChanged,

    /// for dirthdays use DatePickerMode.year
    DatePickerMode initialCalendarMode = DatePickerMode.day,
  }) async {
    DateTime date = initial ?? DateTime.now();
    return await pushPopup(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CalendarDatePicker(
              initialDate: initial ?? DateTime.now(),
              firstDate: first ?? DateTime(1900),
              lastDate: last ?? DateTime.now().add(const Duration(days: 365)),
              initialCalendarMode: initialCalendarMode,
              onDateChanged: (newDate) => date = newDate),
          const SizedBox(height: 20),
          ElevatedButtonWidget('Auswählen', onPressed: () {
            onChanged?.call(date.dateOnly);
            Navigation.pop();
          }),
        ],
      ),
    );
  }

  static void pushWeightPicker({
    double initial = 70,
    int first = 40,
    int last = 200,
    Function(double)? onChanged,
    required Function(double) onSaved,
  }) async {
    return await pushPopup(
      widget: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecimalNumberPicker(
                minValue: first,
                maxValue: last,
                value: initial,
                integerTextMapper: (v) => '$v kg',
                decimalTextMapper: (v) => '${(int.parse(v) * 100).round()} g',
                onChanged: (v) {
                  setState(() {
                    initial = v;
                    onChanged?.call(v);
                  });
                }),
            const SizedBox(height: 20),
            ElevatedButtonWidget('Auswählen', onPressed: () {
              onSaved(initial);
              Navigation.pop();
            }),
          ],
        );
      }),
    );
  }

  static void pushHeightPicker({
    int initial = 170,
    int first = 120,
    int last = 220,
    Function(int)? onChanged,
    required Function(int) onSaved,
  }) async {
    return await pushPopup(
      widget: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NumberPicker(
                minValue: first,
                maxValue: last,
                value: initial,
                textMapper: (v) => '$v cm',
                onChanged: (v) {
                  setState(() {
                    initial = v;
                    onChanged?.call(v);
                  });
                }),
            const SizedBox(height: 20),
            ElevatedButtonWidget('Auswählen', onPressed: () {
              onSaved(initial);
              Navigation.pop();
            }),
          ],
        );
      }),
    );
  }

  static Future<TimeOfDay?> pushTimePicker({
    TimeOfDay? initial,
  }) async {
    return await showTimePicker(
        context: Navigation.context, initialTime: initial ?? TimeOfDay.now());
  }

  static Future<void> replace({required Widget widget}) async =>
      await navigator.pushReplacement(standardRoute(widget));

  static Future<void> flush({required Widget widget}) async => await navigator
      .pushAndRemoveUntil(standardRoute(widget), (route) => false);

  static bool pop() {
    if (navigator.canPop()) {
      navigator.pop();
      return true;
    }
    return false;
  }
}
