part of 'authentication_bloc.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class UserAuthenticatedState extends AuthenticationState {
  const UserAuthenticatedState();
}

class UserUnauthenticatedState extends AuthenticationState {
  const UserUnauthenticatedState();
}
