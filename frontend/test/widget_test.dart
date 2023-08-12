// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fitness_app/widgets/src/my_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Find text in MyErrorWidget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyErrorTestWidget(),
      ),
    );

    expect(find.textContaining('Error'), findsOneWidget);
  });
}

class MyErrorTestWidget extends StatelessWidget {
  const MyErrorTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyErrorWidget(error: 'Error');
  }
}
