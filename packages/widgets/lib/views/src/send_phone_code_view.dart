import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SendPhoneCodeView extends StatefulWidget {
  final Function(TextFieldController phone) onSendPhoneCode;
  const SendPhoneCodeView({
    required this.onSendPhoneCode,
    super.key,
  });

  @override
  State<SendPhoneCodeView> createState() => _SendPhoneCodeViewState();
}

class _SendPhoneCodeViewState extends State<SendPhoneCodeView> {
  TextFieldController phone = TextFieldController.phone();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Phone Sign In',
      primaryButton: ElevatedButtonWidget('Send Code',
          onPressed: () async => await widget.onSendPhoneCode(phone)),
      body: SafeArea(
        child: ColumnWidget(
          margin: EdgeInsets.all(context.config.padding),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            TextFieldWidget(
              controller: phone,
              autofocus: true,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
