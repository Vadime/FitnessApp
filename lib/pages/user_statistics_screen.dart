import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserStatisticsScreen extends StatelessWidget {
  const UserStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        'Weitere Statistiken',
      ),
      body: FailWidget('In Arbeit'),
    );
  }
}
