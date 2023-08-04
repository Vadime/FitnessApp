import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  User? currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
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
                foregroundImage: NetworkImage(
                  currentUser?.photoURL ?? 
                      'https://images.rawpixel.com/image_png_400/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvczc4LW1ja2luc2V5LTAwMDMtam9iNTgzLnBuZw.png',
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
                        title: const Text('Name'),
                        subtitle: Text(currentUser?.displayName ?? '-'),
                      ),
                      ListTile(
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
              title: Text('Role'),
              subtitle: Text('Administrator'),
            ),
          ),
        ],
      ),
    );
  }
}
