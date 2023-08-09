class Friend {
  final String uid;
  final String displayName;
  final String email;
  final String? imageURL;

  const Friend({
    required this.uid,
    required this.displayName,
    required this.email,
    this.imageURL,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        uid: json['uid'],
        displayName: json['displayName'],
        email: json['email'],
        imageURL: json['imageURL'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'imageURL': imageURL,
      };
}
