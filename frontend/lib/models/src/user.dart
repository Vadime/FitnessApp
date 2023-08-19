import 'package:fitnessapp/models/models.dart';

class User {
  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.userRole,
    required this.imageURL,
  });
  final String uid;
  final String email;
  final String displayName;
  final UserRole userRole;
  final String? imageURL;
}
