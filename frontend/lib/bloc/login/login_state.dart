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
      return Messaging.show(
        message: emailBloc.errorText,
      );
    }
    // check if there is an error in password
    if (!passwordBloc.isValid()) {
      return Messaging.show(
        message: passwordBloc.errorText,
      );
    }

    // check if there is an error in rPassword
    if (rPasswordBloc.state.text != passwordBloc.state.text) {
      return Messaging.show(message: "Passwords don't match!");
    }

    await AuthenticationRepository.createUserWithEmailAndPassword(
      email: emailBloc.state.text!,
      password: passwordBloc.state.text!,
    );
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
      return Messaging.show(
        message: emailBloc.errorText,
      );
    }
    // check if there is an error in password
    if (!passwordBloc.isValid()) {
      return Messaging.show(
        message: passwordBloc.errorText,
      );
    }

    await AuthenticationRepository.signInWithEmailAndPassword(
      email: emailBloc.state.text!,
      password: passwordBloc.state.text!,
    );
  }
}

class LoginSendPasswordState extends LoginState {
  EmailBloc emailBloc = EmailBloc();
  LoginSendPasswordState() : super(page: 2, name: 'Send Password');

  @override
  Future<void> onDone(BuildContext context) async {
    // check if there is an error in email
    if (!emailBloc.isValid()) {
      return Messaging.show(
        message: emailBloc.errorText,
      );
    }

    await AuthenticationRepository.sendPasswordResetEmail(
      email: emailBloc.state.text!,
    ).then((value) {
      Messaging.show(message: 'Email sent!');
      context.read<LoginBloc>().add(LoginSignInEvent());
    }).catchError(
      (e) {
        Messaging.show(message: e.toString().split('] ').last);
        return;
      },
    );
  }
}
