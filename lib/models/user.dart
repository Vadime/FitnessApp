import 'package:burnfat/models/database_model.dart';

class User extends DatabaseModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;

  const User({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
  }) : super();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, name: $name, photoUrl: $photoUrl)';
  }


}
