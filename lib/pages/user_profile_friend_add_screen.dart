import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendAddScreen extends StatefulWidget {
  const UserProfileFriendAddScreen({super.key});

  @override
  State<UserProfileFriendAddScreen> createState() =>
      _UserProfileFriendAddScreenState();
}

class _UserProfileFriendAddScreenState
    extends State<UserProfileFriendAddScreen> {
  TextFieldController emailController = TextFieldController.email();
  TextFieldController phoneController = TextFieldController.phone();
  ContactType type = ContactType.email;

  List<Friend> friends = [];

  @override
  void initState() {
    getFriends();
    super.initState();
  }

  void getFriends() async {
    friends = await UserRepository.getFriends();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Freund hinzufügen',
      body: ColumnWidget(
        safeArea: true,
        margin: const EdgeInsets.all(20),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardWidget.single(
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    controller: type == ContactType.email
                        ? emailController
                        : phoneController,
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 10),
                IconButtonWidget(
                  Icons.search_rounded,
                  foregroundColor: Colors.orange,
                  onPressed: () async {
                    // Search for users with the email/phone number from controller
                    // put found users into list
                    // check if there is an error in email
                    if (type == ContactType.email) {
                      if (emailController.isValid()) {
                        // add friend
                        try {
                          friends = await UserRepository.searchUsersByEmail(
                            emailController.text,
                          );
                        } catch (e) {
                          emailController.setError(e.toString());
                          return;
                        }
                      }
                    }

                    // check if there is an error in email
                    if (type == ContactType.phone) {
                      if (phoneController.isValid()) {
                        // add friend
                        try {
                          friends = await UserRepository.searchUsersByPhone(
                            phoneController.text,
                          );
                        } catch (e) {
                          phoneController.setError(e.toString());
                          return;
                        }
                      }
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButtonWidget(
              'Suche ändern auf ${type == ContactType.email ? ContactType.phone.str : ContactType.email.str}',
              onPressed: () => setState(
                () => type == ContactType.email
                    ? type = ContactType.phone
                    : type = ContactType.email,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextWidget(
            'Suchergebnisse',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),

          // Liste von allen Nutzern mit der Email/Telefonnummer
          if (friends.isEmpty)
            const SizedBox(
              height: 100,
              child: FailWidget('Keine Nutzer gefunden'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTileWidget(
                    title: friends[index].displayName,
                    leading: ImageWidget(
                      NetworkImage(friends[index].imageURL ?? ''),
                      width: 50,
                      height: 50,
                      radius: 25,
                    ),
                    trailing: TextButtonWidget(
                      'Folgen',
                      onPressed: () async {
                        // check if there is an error in email
                        if (type == ContactType.email) {
                          if (emailController.isValid()) {
                            // add friend
                            try {
                              await UserRepository.addFriendByEmail(
                                emailController.text,
                              );
                              Navigation.flush(
                                widget: const HomeScreen(initialIndex: 3),
                              );
                            } catch (e) {
                              emailController.setError(e.toString());
                              return;
                            }
                          }
                        }

                        // check if there is an error in email
                        if (type == ContactType.phone) {
                          if (phoneController.isValid()) {
                            // add friend
                            try {
                              await UserRepository.addFriendByPhone(
                                phoneController.text,
                              );
                              Navigation.flush(
                                widget: const HomeScreen(initialIndex: 3),
                              );
                            } catch (e) {
                              phoneController.setError(e.toString());
                              return;
                            }
                          }
                        }
                        setState(() {});
                      },
                    ),
                  );
                },
                itemCount: friends.length,
              ),
            ),
        ],
      ),
    );
  }
}
