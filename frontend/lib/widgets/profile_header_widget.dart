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
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CardWidget(
            padding: const EdgeInsets.all(20),
            children: [
              ListTileWidget(
                title: 'Name',
                subtitle: currentUser?.displayName ?? '-',
              ),
              const SizedBox(height: 10),
              ListTileWidget(
                title: 'Email',
                subtitle: currentUser?.email ?? '-',
                subtitleOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
