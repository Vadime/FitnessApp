part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginSignInEvent extends LoginEvent {}

class LoginSignUpEvent extends LoginEvent {}

class LoginSendPasswordEvent extends LoginEvent {}
