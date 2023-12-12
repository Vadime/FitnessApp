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
    if (currentUser == null) return const SizedBox();
    return Row(
      children: [
        Center(
          child: ImageWidget(
            currentUser!.imageURL == null
                ? null
                : NetworkImage(currentUser!.imageURL!),
            width: 100,
            height: 100,
            radius: 50,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CardWidget(
            padding: const EdgeInsets.fromLTRB(
              //context.config.padding,
              0,
              0,
              //context.config.padding,
              0,
              0,
            ),
            children: [
              ListTileWidget(
                title: 'Name',
                subtitle: currentUser!.displayName,
              ),
              ListTileWidget(
                title: currentUser!.contactAdress.name,
                subtitle: currentUser!.contactAdress.value,
                subtitleOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
