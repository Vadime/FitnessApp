library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../text_field.dart';

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
    return BlocBuilder<TextFieldBloc, TextFieldState>(
      bloc: bloc,
      builder: (_, state) => TextField(
        controller: bloc.controller,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        obscureText: state.obscure && !state.visible,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          errorMaxLines: 1,
          labelText: state.hintText,
          errorText: state.errorText,
          suffixIcon: (state.obscure)
              ? GestureDetector(
                  onTapDown: (_) => bloc.add(
                    TextFieldEvent(state.text ?? '', true),
                  ),
                  onTapUp: (_) => bloc.add(
                    TextFieldEvent(state.text ?? '', false),
                  ),
                  onTapCancel: () => bloc.add(
                    TextFieldEvent(state.text ?? '', false),
                  ),
                  child: Icon(
                    state.visible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                )
              : null,
        ),
        onChanged: (text) => bloc.add(TextFieldEvent(text, state.visible)),
      ),
    );
  }
}
