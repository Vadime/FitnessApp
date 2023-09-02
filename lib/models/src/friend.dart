import 'package:fitnessapp/models/models.dart';

class Friend {
  final String uid;
  final String displayName;
  final ContactMethod contactMethod;
  final String? imageURL;

  const Friend({
    required this.uid,
    required this.displayName,
    required this.contactMethod,
    this.imageURL,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        uid: json['uid'],
        displayName: json['displayName'],
        contactMethod: ContactMethod.fromJson(
          json['contactMethod'],
        ),
        imageURL: json['imageURL'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'contactMethod': contactMethod.toJson(),
        'imageURL': imageURL,
      };

  factory Friend.fromUser(User user) => Friend(
        uid: user.uid,
        displayName: user.displayName,
        contactMethod: user.contactAdress,
        imageURL: user.imageURL,
      );
}
