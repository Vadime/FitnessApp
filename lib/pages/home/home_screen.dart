import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:fitnessapp/pages/admin_exercise_list_page.dart';
import 'package:fitnessapp/pages/admin_profile_page.dart';
import 'package:fitnessapp/pages/admin_workout_add_screen.dart';
import 'package:fitnessapp/pages/admin_workout_list_page.dart';
import 'package:fitnessapp/pages/user_exercise_add_screen.dart';
import 'package:fitnessapp/pages/user_exercise_list_page.dart';
import 'package:fitnessapp/pages/user_friend_list_page.dart';
import 'package:fitnessapp/pages/user_health_edit_screen.dart';
import 'package:fitnessapp/pages/user_health_page.dart';
import 'package:fitnessapp/pages/user_profile_friend_add_screen.dart';
import 'package:fitnessapp/pages/user_profile_page.dart';
import 'package:fitnessapp/pages/user_settings_screen.dart';
import 'package:fitnessapp/pages/user_workout_add_screen.dart';
import 'package:fitnessapp/pages/user_workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

part 'admin_home_screen.dart';
part 'user_home_screen.dart';

class HomeScreen extends StatelessWidget {
  final int initialIndex;
  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) =>
      UserRepository.currentUserRole == UserRole.admin
          ? _AdminHomeScreen(initialIndex: initialIndex)
          : _UserHomeScreen(initialIndex: initialIndex);
}
