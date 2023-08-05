extension UserRoleExtension on UserRole {
  String get strName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.user:
        return 'User';
    }
  }
}

enum UserRole {
  admin,
  user,
}
