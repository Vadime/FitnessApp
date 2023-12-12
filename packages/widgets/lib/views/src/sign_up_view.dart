import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SignUpView extends StatefulWidget {
  final Function() toSignIn;
  final Function(TextFieldController email, TextFieldController password,
      CheckboxController agree) signUp;
  final Widget agreementText;
  const SignUpView({
    required this.toSignIn,
    required this.signUp,
    required this.agreementText,
    super.key,
  });

  @override
  State<SignUpView> createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  TextFieldController email = TextFieldController.email();
  TextFieldController password = TextFieldController.password();
  CheckboxController agree = CheckboxController(false);

  signUp() async => await widget.signUp(email, password, agree);

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      maxWidth: 600,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        LoginHeader(
          'Sign Up',
          'Already have an account? ',
          TextButtonWidget(
            'Sign In',
            onPressed: widget.toSignIn,
          ),
        ),

        CardWidget(
          margin: EdgeInsets.fromLTRB(
              context.config.padding,
              context.config.paddingH,
              context.config.padding,
              context.config.paddingH),
          children: [
            TextFieldWidget(controller: email),
            TextFieldWidget(controller: password),
          ],
        ),
        // checkbox and terms of service
        Padding(
          padding: EdgeInsets.fromLTRB(
              context.config.padding, 0, context.config.padding, 0),
          child: Row(
            children: [
              CheckboxWidget(controller: agree),
              SizedBox(width: context.config.paddingH),
              Expanded(child: widget.agreementText),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
