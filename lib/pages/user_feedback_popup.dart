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
  final TextFieldController _feedbackController =
      TextFieldController('Feedback');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('User Feedback', style: context.textTheme.titleLarge),
        const SizedBox(height: 20),
        TextFieldWidget(
          controller: _feedbackController,
          maxLines: null,
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Send',
          onPressed: () async {
            // check if feedback is empty
            if (_feedbackController.text.isEmpty) {
              Messaging.info(
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
        ),
      ],
    );
  }
}
