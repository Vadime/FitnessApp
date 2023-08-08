import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class UserFeedbackListScreen extends StatefulWidget {
  const UserFeedbackListScreen({super.key});

  @override
  State<UserFeedbackListScreen> createState() => _UserFeedbackListScreenState();
}

class _UserFeedbackListScreenState extends State<UserFeedbackListScreen> {
  List<MyFeedback>? feedbacks;

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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('User Feedback'),
      ),
      body: (feedbacks == null)
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : (feedbacks!.isEmpty)
              ? Center(
                  child: Text(
                    'No feedbacks yet',
                    style: context.textTheme.labelSmall,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 76, 20, 20)
                      .addSafeArea(context),
                  itemBuilder: (context, index) => Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 10),
                        ListTile(
                          title: Text(feedbacks![index].name),
                          subtitle: Text(feedbacks![index].feedback),
                          isThreeLine: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Text(
                            feedbacks![index].date,
                            style: context.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: feedbacks!.length,
                ),
    );
  }
}
