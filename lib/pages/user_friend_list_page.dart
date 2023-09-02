import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserFriendListPage extends StatefulWidget {
  const UserFriendListPage({super.key});

  @override
  State<UserFriendListPage> createState() => _UserFriendListPageState();
}

class _UserFriendListPageState extends State<UserFriendListPage> {
  List<Friend>? friends;

  @override
  void initState() {
    super.initState();
    UserRepository.getFriends()
        .then((value) => setState(() => friends = value));
  }

  @override
  Widget build(BuildContext context) {
    if (friends == null) {
      return const SizedBox(
        height: 100,
        child: LoadingWidget(),
      );
    } else if (friends!.isEmpty) {
      return const SizedBox(
        height: 100,
        child: FailWidget('You have no friends'),
      );
    } else {
      return ListView(
        children: [
          const SizedBox(height: 10),
          for (Friend friend in friends!)
            ListTileWidget(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              padding: const EdgeInsets.all(20),
              title: friend.displayName,
              subtitle: friend.contactMethod.value,
              onTap: () => Navigation.pushPopup(
                widget: UserProfileFriendsGraphPopup(
                  friend: friend,
                ),
              ),
              trailing: ImageWidget(
                NetworkImage(friend.imageURL ?? ''),
                width: 40,
                height: 40,
              ),
            ),
          const SizedBox(height: 10),
        ],
      );
    }
  }
}
