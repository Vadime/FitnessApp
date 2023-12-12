import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SignInView extends StatefulWidget {
  final Function() toSignUp;
  final Function() toSendPassword;
  final dynamic Function(
      TextFieldController email, TextFieldController password) signIn;
  const SignInView({
    required this.toSignUp,
    required this.toSendPassword,
    required this.signIn,
    super.key,
  });

  @override
  State<SignInView> createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  TextFieldController email = TextFieldController.email();
  TextFieldController password = TextFieldController.password();

  signIn() async => await widget.signIn(email, password);

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      maxWidth: 600,
      children: [
        const Spacer(),
        LoginHeader(
          'Sign In',
          "Don't have an Account? ",
          TextButtonWidget(
            'Sign Up',
            onPressed: widget.toSignUp,
          ),
        ),
        CardWidget(
          maxWidth: 600,
          margin: EdgeInsets.fromLTRB(
              context.config.padding,
              context.config.paddingH,
              context.config.padding,
              context.config.paddingH),
          children: [
            TextFieldWidget(controller: email),
            TextFieldWidget(controller: password)
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButtonWidget(
            'Forgot password?',
            onPressed: widget.toSendPassword,
            margin: EdgeInsets.fromLTRB(
                context.config.padding, 0, context.config.padding, 0),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
