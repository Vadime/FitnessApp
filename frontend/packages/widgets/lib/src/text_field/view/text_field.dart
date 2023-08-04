library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/src/text_field/text_field.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.bloc,
    this.autocorrect = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextFieldBloc bloc;
  final bool autocorrect;

  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    var c = TextEditingController(text: bloc.state.text);
    return BlocBuilder<TextFieldBloc, TextFieldState>(
      bloc: bloc,
      builder: (_, state) => TextField(
        controller: c,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: bloc.hintText,
          errorText: bloc.state.errorText,
        ),
        onChanged: (text) => bloc.add(TextFieldChangedEvent(text)),
      ),
    );
  }
}
