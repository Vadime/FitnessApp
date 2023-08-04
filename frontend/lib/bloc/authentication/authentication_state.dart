part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class UserAuthenticatedState extends AuthenticationState {
  const UserAuthenticatedState();
  @override
  List<Object?> get props => [];
}

class UserUnauthenticatedState extends AuthenticationState {
  const UserUnauthenticatedState();

  @override
  List<Object?> get props => [];
}
