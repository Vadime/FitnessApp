import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/user_weight_graph.dart';
import 'package:fitnessapp/widgets/user_workout_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  List<WorkoutStatistic>? statistics;
  List<Health>? healthList;

  @override
  void initState() {
    UserRepository.getWorkoutDatesStatistics().then((value) {
      statistics = value;
      setState(() {});
    });
    HealthRepository.getHealthHistory().then((value) {
      healthList = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    User? currentUser = UserRepository.currentUser;

    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        ProfileHeaderWidget(currentUser: currentUser),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ColumnWidget(
                margin: const EdgeInsets.all(10),
                children: [
                  Text(
                    currentUser!.createdAt!.ddMMYYYY,
                    style: context.textTheme.bodyLarge,
                  ),
                  Text('Member since', style: context.textTheme.labelSmall),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
              child: VerticalDivider(),
            ),
            Expanded(
              child: ColumnWidget(
                margin: const EdgeInsets.all(10),
                children: [
                  Text(
                    statistics?.length.toString() ?? '0',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text('Workouts done', style: context.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextWidget(
          'Statistiken',
          style: context.textTheme.labelLarge,
        ),
        const SizedBox(height: 20),
        if (statistics != null)
          UserWorkoutGraph(
            statistics: statistics!,
          ),
        const SizedBox(height: 20),
        if (healthList != null)
          UserWeightGraph(
            healthList: healthList!,
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
