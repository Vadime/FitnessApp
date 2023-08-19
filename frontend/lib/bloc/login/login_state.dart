part of 'login_bloc.dart';

abstract class LoginState {
  final int page;
  final String name;
  const LoginState({this.page = -1, this.name = '-'});

  Future<void> onDone(BuildContext context);
}

class LoginSignUpState extends LoginState {
  TextFieldController emailBloc = TextFieldController.email();
  TextFieldController passwordBloc = TextFieldController.password();
  TextFieldController rPasswordBloc =
      TextFieldController.password(labelText: 'Repeat Password');

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
    if (rPasswordBloc.text != passwordBloc.text) {
      return Navigation.pushMessage(message: "Passwords don't match!");
    }
    try {
      await UserRepository.createUserWithEmailAndPassword(
        email: emailBloc.text,
        password: passwordBloc.text,
      );
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}

class LoginSignInState extends LoginState {
  TextFieldController emailBloc = TextFieldController.email();
  TextFieldController passwordBloc = TextFieldController.password();

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
        email: emailBloc.text,
        password: passwordBloc.text,
      );
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}

class LoginSendPasswordState extends LoginState {
  TextFieldController emailBloc = TextFieldController.email();
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
        email: emailBloc.text,
      );
      Navigation.pushMessage(message: 'Email sent!');
      if (context.mounted) context.read<LoginBloc>().add(LoginSignInEvent());
    } catch (e) {
      Navigation.pushMessage(message: e.toString());
      return;
    }
  }
}
