import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/health.dart';

extension ContactTypeExtension on ContactType {
  get str {
    switch (this) {
      case ContactType.email:
        return 'Email';
      case ContactType.phone:
        return 'Telefon';
      default:
        return 'Unbekannt';
    }
  }

  toJson() {
    switch (this) {
      case ContactType.email:
        return 'email';
      case ContactType.phone:
        return 'phone';
      default:
        return 'unknown';
    }
  }
}

enum ContactType { email, phone, unknown }

ContactType contactTypeFromJson(String json) {
  switch (json) {
    case 'email':
      return ContactType.email;
    case 'phone':
      return ContactType.phone;
    default:
      return ContactType.unknown;
  }
}

class ContactMethod {
  final String value;
  final ContactType type;

  const ContactMethod({
    required this.value,
    required this.type,
  });

  const ContactMethod.email(String email)
      : this(value: email, type: ContactType.email);
  const ContactMethod.phone(String phone)
      : this(value: phone, type: ContactType.phone);
  const ContactMethod.unknown() : this(value: '-', type: ContactType.unknown);

  String get name => type.str;

  factory ContactMethod.fromJson(Map<Object?, Object?> json) => ContactMethod(
        value: json['value'].toString(),
        type: contactTypeFromJson(json['type'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.toJson(),
      };
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
