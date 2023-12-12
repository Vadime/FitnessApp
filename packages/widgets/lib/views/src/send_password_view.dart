import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SendPasswordView extends StatefulWidget {
  final Function() toSignIn;
  final Function(TextFieldController email) sendPassword;
  const SendPasswordView({
    required this.toSignIn,
    required this.sendPassword,
    super.key,
  });

  @override
  State<SendPasswordView> createState() => SendPasswordViewState();
}

class SendPasswordViewState extends State<SendPasswordView> {
  TextFieldController email = TextFieldController.email();

  sendPassword() async => await widget.sendPassword(email);

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      maxWidth: 600,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        LoginHeader(
          'Send Password',
          'You have your Password again? ',
          TextButtonWidget(
            'Sign In',
            onPressed: widget.toSignIn,
          ),
        ),
        TextFieldWidget(
          maxWidth: 600,
          controller: email,
          margin: EdgeInsets.fromLTRB(
              context.config.padding,
              context.config.paddingH,
              context.config.padding,
              context.config.paddingH),
        ),
        const Spacer()
      ],
    );
  }
}
