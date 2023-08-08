import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/profile_password_change_screen.dart';
import 'package:fitness_app/view/profile_theme_change_popup.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SafeArea(
          bottom: false,
          child: SizedBox(height: 0),
        ),
        Row(
          children: [
            CircleAvatar(
              radius: context.shortestSide / 7,
              backgroundColor: context.theme.cardColor,
              foregroundImage: currentUser?.imageURL == null
                  ? null
                  : NetworkImage(
                      currentUser!.imageURL!,
                    ),
              child: Icon(
                Icons.person_4_rounded,
                size: context.shortestSide / (5),
                color: context.theme.scaffoldBackgroundColor,
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(currentUser?.displayName ?? '-'),
                    ),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(currentUser?.email ?? '-'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Role'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.accents[6],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.accents[6],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('User Statistics'),
                trailing: Icon(
                  Icons.analytics_rounded,
                  color: Colors.accents[1],
                ),
                onTap: () => Navigation.push(
                  widget: const UserStatisticsListScreen(),
                ),
              ),
              // navigate to UserfeedbackListScreen
              ListTile(
                title: const Text('User Feedback'),
                trailing: Icon(
                  Icons.feedback_rounded,
                  color: Colors.accents[2],
                ),
                onTap: () => Navigation.push(
                  widget: const UserFeedbackListScreen(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              // navigate to UserStatisticsScreen

              // toggle theme mode
              ListTile(
                title: const Text('Change Theme'),
                trailing: Icon(
                  {
                    ThemeMode.system: Icons.settings_rounded,
                    ThemeMode.light: Icons.light_mode_rounded,
                    ThemeMode.dark: Icons.dark_mode_rounded,
                  }[context.read<ThemeBloc>().state],
                  color: Colors.accents[3],
                ),
                onTap: () =>
                    Navigation.pushPopup(widget: const ThemeChangePopup()),
              ),
              // change password
              ListTile(
                title: const Text('Change Password'),
                trailing: Icon(
                  Icons.password_rounded,
                  color: Colors.accents[4],
                ),
                // sign out user from firebase auth
                onTap: () =>
                    Navigation.push(widget: const PasswordChangeScreen()),
              ),
              // sign out
              ListTile(
                title: const Text('Sign Out'),
                trailing: Icon(
                  Icons.logout_rounded,
                  color: Colors.accents[0],
                ),
                // sign out user from firebase auth
                onTap: () => UserRepository.signOutCurrentUser(),
              ),
            ],
          ),
        ),
        const SafeArea(
          top: false,
          child: SizedBox(height: 0),
        ),
      ],
    );
  }
}

extension on String {
  DateTime toDateTime() {
    var arr = split('.');
    return DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
  }
}

class UserStatisticsListScreen extends StatelessWidget {
  const UserStatisticsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Statistics'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<dynamic>>(
            future: FirebaseFirestore.instance
                .collectionGroup('workoutStatistics')
                .get()
                .then((value) {
              return (value.docs
                  .map(
                    (e) => e.data()['date'] ?? DateTime.now().formattedDate,
                  )
                  .toList());
            }),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<String> dates = snapshot.data!.cast<String>()
                ..sort(
                  (a, b) => a.toDateTime().compareTo(b.toDateTime()),
                );

              Map<String, int> workoutCount = {};
              // count number of workouts done in one day
              for (var date in dates) {
                if (workoutCount.containsKey(date)) {
                  workoutCount[date] = workoutCount[date]! + 1;
                } else {
                  workoutCount.putIfAbsent(date, () => 1);
                }
              }

              findMax(it) {
                var max = 0;
                for (var i in it.values) {
                  if (i > max) {
                    max = i;
                  }
                }
                return max;
              }

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  // one over the max value of the workout count
                  maxY: findMax(workoutCount).toDouble() + 1,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade900,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} workouts',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      //axisNameWidget: const Text('Dates'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (index, meta) {
                          return Text(
                            (workoutCount.keys
                                    .elementAt(index.toInt())
                                    .split('.')
                                  ..removeLast())
                                .join('.')
                                .toString(),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      axisNameWidget:
                          const Text('Anzahl der Workouts aller Nutzer'),
                      sideTitles: SideTitles(
                        showTitles: false,
                        interval: 1,
                        getTitlesWidget: (index, meta) {
                          return Text(index.toInt().toString());
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: const FlGridData(
                    show: false,
                  ),
                  barGroups: [
                    for (int i = 0; i < workoutCount.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            fromY: 0.1,
                            toY: workoutCount.values.toList()[i].toDouble(),
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserFeedbackListScreen extends StatefulWidget {
  const UserFeedbackListScreen({super.key});

  @override
  State<UserFeedbackListScreen> createState() => _UserFeedbackListScreenState();
}

class _UserFeedbackListScreenState extends State<UserFeedbackListScreen> {
  List<MyFeedback> feedbacks = [];

  @override
  void initState() {
    super.initState();
    // get all feedbacks from firebase

    FirebaseFirestore.instance.collection('feedback').get().then((value) {
      setState(() {
        feedbacks =
            value.docs.map((e) => MyFeedback.fromJson(e.data())).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                title: Text(feedbacks[index].name),
                subtitle: Text(feedbacks[index].feedback),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  feedbacks[index].date,
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: feedbacks.length,
      ),
    );
  }
}
