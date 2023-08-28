import 'package:fitnessapp/models/models.dart';

enum ContactType { email, phone, unknown }

class ContactMethod {
  final String name;
  final String value;
  final ContactType type;

  const ContactMethod(
      {required this.name, required this.value, required this.type});

  const ContactMethod.email(String email)
      : this(name: 'Email', value: email, type: ContactType.email);
  const ContactMethod.phone(String phone)
      : this(name: 'Phone', value: phone, type: ContactType.phone);
  const ContactMethod.unknown()
      : this(name: 'Contact', value: '-', type: ContactType.unknown);
}

class User {
  User({
    required this.uid,
    required this.contactAdress,
    required this.displayName,
    required this.userRole,
    required this.imageURL,
  });
  final String uid;
  final ContactMethod contactAdress;
  final String displayName;
  final UserRole userRole;
  final String? imageURL;
}
