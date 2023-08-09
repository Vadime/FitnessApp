import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

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
        CircleAvatar(
          radius: context.shortestSide / 8,
          backgroundColor: context.theme.cardColor,
          foregroundImage: currentUser?.imageURL == null
              ? null
              : NetworkImage(
                  currentUser?.imageURL ?? '',
                ),
          child: Icon(
            Icons.person_4_rounded,
            size: context.shortestSide / (5),
            color: context.theme.scaffoldBackgroundColor,
          ),
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
