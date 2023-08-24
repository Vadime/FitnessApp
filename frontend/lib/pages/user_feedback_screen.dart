import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserFeedbackPopup extends StatefulWidget {
  const UserFeedbackPopup({super.key});

  @override
  State<UserFeedbackPopup> createState() => _UserFeedbackPopupState();
}

class _UserFeedbackPopupState extends State<UserFeedbackPopup> {
  final TextEditingController _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('User Feedback', style: context.textTheme.titleLarge),
        const SizedBox(height: 20),
        CardWidget.single(
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
    );
  }
}
