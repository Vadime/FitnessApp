import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(height: 20),
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              CircleAvatar(
                radius: context.shortestSide / 7,
                backgroundColor: context.theme.cardColor,
                foregroundImage: currentUser?.imageURL == null
                    ? null
                    : NetworkImage(
                        currentUser!.imageURL!,
                      ),
                child: Icon(
                  Icons.person_4_rounded,
                  size: context.shortestSide / (5),
                  color: context.theme.scaffoldBackgroundColor,
                ),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                        subtitle: Text(currentUser?.email ?? '-'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Card(
            margin: EdgeInsets.all(20),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              title: Text('Role'),
              subtitle: Text('Administrator'),
            ),
          ),
          const Spacer(),
          Text(
            'Vieleicht noch ein paar Statistiken von Nutzern\n👍',
            textAlign: TextAlign.center,
            style: context.textTheme.labelMedium,
          ),
          const Spacer(),
          const SafeArea(
            top: false,
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
