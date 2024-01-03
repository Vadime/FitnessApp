import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class VerifyPhoneCodeView extends StatefulWidget {
  final Function(TextFieldController code) verifyPhoneCode;

  const VerifyPhoneCodeView({required this.verifyPhoneCode, super.key});

  @override
  State<VerifyPhoneCodeView> createState() => _VerifyPhoneCodeViewState();
}

class _VerifyPhoneCodeViewState extends State<VerifyPhoneCodeView> {
  TextFieldController code = TextFieldController.code(labelText: 'Verify Code');

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Verify Code',
      primaryButton: ElevatedButtonWidget('Login', onPressed: () async {
        if (!code.isValid()) return;
        try {
          await widget.verifyPhoneCode(code);
        } catch (e) {
          code.setError(e.toString());
          return;
        }
      }),
      body: SafeArea(
        child: ColumnWidget(
          margin: EdgeInsets.all(context.config.padding),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            TextFieldWidget(
              controller: code,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
