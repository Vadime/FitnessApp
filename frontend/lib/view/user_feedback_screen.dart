import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class UserFeedbackScreen extends StatefulWidget {
  const UserFeedbackScreen({super.key});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        actions: [
          //send
          IconButton(
            onPressed: () async {
              // check if feedback is empty
              if (_feedbackController.text.isEmpty) {
                Messaging.show(
                  message: 'Feedback is empty',
                );
                return;
              }

              // create feedback object
              MyFeedback feedback = MyFeedback(
                name: UserRepository.currentUser!.displayName,
                feedback: _feedbackController.text,
                date: DateTime.now().formattedDate,
              );

              // save in firestore
              await FirebaseFirestore.instance
                  .collection('feedback')
                  .add(feedback.toJson());

              // show snackbar
              Messaging.show(
                message: 'Feedback sent',
              );

              // pop screen
              Navigation.pop();
            },
            tooltip: 'Send',
            icon: Icon(
              Icons.send_rounded,
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -0.5),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
      ),
    );
  }
}
