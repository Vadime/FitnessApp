part of 'authentication_bloc.dart';

abstract class _AuthenticationEvent {
  const _AuthenticationEvent();
}

// go to onboarding screen
class _UserAuthenticatedEvent extends _AuthenticationEvent {
  const _UserAuthenticatedEvent();
}

// go to home screen, because user is authenticated
// (mostly) from login screen
class _UserUnauthenticatedEvent extends _AuthenticationEvent {
  const _UserUnauthenticatedEvent();
}
