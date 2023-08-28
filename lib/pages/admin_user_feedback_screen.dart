import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminUserFeedbackScreen extends StatefulWidget {
  const AdminUserFeedbackScreen({super.key});

  @override
  State<AdminUserFeedbackScreen> createState() =>
      _AdminUserFeedbackScreenState();
}

class _AdminUserFeedbackScreenState extends State<AdminUserFeedbackScreen> {
  List<MyFeedback> feedbacks = [];

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  loadFeedback() async {
    feedbacks = await FeedbackRepository.adminFeedbackAsFuture;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(
        'User Feedback',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SafeArea(bottom: false, child: SizedBox()),
          for (int index = 0; index < feedbacks.length; index++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  feedbacks[index].date,
                  style: context.textTheme.labelSmall,
                ),
                const SizedBox(height: 10),
                ListTileWidget(
                  padding: const EdgeInsets.all(20),
                  title: feedbacks[index].name,
                  subtitle: feedbacks[index].feedback,
                ),
                const SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );
  }
}
