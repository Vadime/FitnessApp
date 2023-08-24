import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final User? currentUser;
  const ProfileHeaderWidget({
    required this.currentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageWidget(
          NetworkImage(currentUser!.imageURL!),
          width: 100,
          height: 100,
          radius: 50,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  title: const Text('Name'),
                  subtitle: Text(currentUser?.displayName ?? '-'),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  title: const Text('Email'),
                  subtitle: (currentUser?.email ?? '-').length > 20
                      ? FittedBox(child: Text(currentUser?.email ?? '-'))
                      : Text(currentUser?.email ?? '-'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
