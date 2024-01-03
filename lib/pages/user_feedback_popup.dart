import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserFeedbackScreen extends StatefulWidget {
  const UserFeedbackScreen({super.key});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  final TextFieldController _feedbackController =
      TextFieldController('Feedback');
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Nutzer Feedback',
      primaryButton: ElevatedButtonWidget(
        'Senden',
        onPressed: () async {
          // check if feedback is empty
          if (!_feedbackController.isValid()) return;

          await FeedbackRepository.addFeedback(
            MyFeedback(
              name: UserRepository.currentUser!.displayName,
              feedback: _feedbackController.text,
              date: DateTime.now().ddMMYYYY,
            ),
          );

          // pop screen
          Navigation.pop();
        },
      ),
      body: Center(
        child: TextFieldWidget(
          margin: const EdgeInsets.all(20),
          controller: _feedbackController,
          maxLines: null,
        ),
      ),
    );
  }
}
