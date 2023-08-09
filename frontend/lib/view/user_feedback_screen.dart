import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class UserFeedbackPopup extends StatefulWidget {
  const UserFeedbackPopup({super.key});

  @override
  State<UserFeedbackPopup> createState() => _UserFeedbackPopupState();
}

class _UserFeedbackPopupState extends State<UserFeedbackPopup> {
  final TextEditingController _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('User Feedback', style: context.textTheme.titleLarge),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                maxLines: null,
                controller: _feedbackController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Feedback',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // check if feedback is empty
              if (_feedbackController.text.isEmpty) {
                Navigation.pushMessage(
                  message: 'Feedback is empty',
                );
                return;
              }

              await FeedbackRepository.addFeedback(
                MyFeedback(
                  name: UserRepository.currentUser!.displayName,
                  feedback: _feedbackController.text,
                  date: DateTime.now().formattedDate,
                ),
              );

              // pop screen
              Navigation.pop();
            },
            child: const Text(
              'Send',
            ),
          ),
        ],
      ),
    );
  }
}
