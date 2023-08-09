part of 'login_bloc.dart';

abstract class LoginState {
  final int page;
  final String name;
  const LoginState({this.page = -1, this.name = '-'});

  Future<void> onDone(BuildContext context);
}

class LoginSignUpState extends LoginState {
  EmailBloc emailBloc = EmailBloc();
  PasswordBloc passwordBloc = PasswordBloc();
  PasswordBloc rPasswordBloc = PasswordBloc(hintText: 'Repeat Password');

  LoginSignUpState() : super(page: 0, name: 'Sign Up');

  @override
  Future<void> onDone(BuildContext context) async {
    // check if there is an error in email
    if (!emailBloc.isValid()) {
      return Navigation.pushMessage(
        message: emailBloc.errorText,
      );
    }
    // check if there is an error in password
    if (!passwordBloc.isValid()) {
      return Navigation.pushMessage(
        message: passwordBloc.errorText,
      );
    }

    // check if there is an error in rPassword
    if (rPasswordBloc.state.text != passwordBloc.state.text) {
      return Navigation.pushMessage(message: "Passwords don't match!");
    }
    try {
      await UserRepository.createUserWithEmailAndPassword(
        email: emailBloc.state.text!,
        password: passwordBloc.state.text!,
      );
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}

class LoginSignInState extends LoginState {
  EmailBloc emailBloc = EmailBloc();
  PasswordBloc passwordBloc = PasswordBloc();

  LoginSignInState() : super(page: 1, name: 'Sign In');

  @override
  Future<void> onDone(BuildContext context) async {
    // check if there is an error in email
    if (!emailBloc.isValid()) {
      return Navigation.pushMessage(
        message: emailBloc.errorText,
      );
    }
    // check if there is an error in password
    if (!passwordBloc.isValid()) {
      return Navigation.pushMessage(
        message: passwordBloc.errorText,
      );
    }
    try {
      await UserRepository.signInWithEmailAndPassword(
        email: emailBloc.state.text!,
        password: passwordBloc.state.text!,
      );
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}

class LoginSendPasswordState extends LoginState {
  EmailBloc emailBloc = EmailBloc();
  LoginSendPasswordState() : super(page: 2, name: 'Send Password');

  @override
  Future<void> onDone(BuildContext context) async {
    // check if there is an error in email
    if (!emailBloc.isValid()) {
      return Navigation.pushMessage(
        message: emailBloc.errorText,
      );
    }
    try {
      await UserRepository.sendPasswordResetEmail(
        email: emailBloc.state.text!,
      );
      Navigation.pushMessage(message: 'Email sent!');
      if (context.mounted) context.read<LoginBloc>().add(LoginSignInEvent());
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}
