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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldWidget(
          controller: phone,
          autofocus: true,
        ),
        SizedBox(height: context.config.padding),
        ElevatedButtonWidget('Send Code',
            onPressed: () async => await widget.onSendPhoneCode(phone))
      ],
    );
  }
}
