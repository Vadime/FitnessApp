part of 'authentication_bloc.dart';

abstract class _AuthenticationEvent extends Equatable {
  const _AuthenticationEvent();
}

// go to onboarding screen
class _UserAuthenticatedEvent extends _AuthenticationEvent {

  const _UserAuthenticatedEvent();

  @override
  List<Object?> get props => [];
}

// go to home screen, because user is authenticated
// (mostly) from login screen
class _UserUnauthenticatedEvent extends _AuthenticationEvent {
  const _UserUnauthenticatedEvent();

  @override
  List<Object?> get props => [];
}
