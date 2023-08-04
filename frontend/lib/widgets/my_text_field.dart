library widgets;

import 'package:fitness_app/bloc/widgets/my_text_field_bloc.dart';
import 'package:fitness_app/bloc/widgets/my_text_field_event.dart';
import 'package:fitness_app/bloc/widgets/my_text_field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.bloc,
    this.autocorrect = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final MyTextFieldBloc bloc;
  final bool autocorrect;

  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    var c = TextEditingController(text: bloc.state.text);
    return BlocBuilder<MyTextFieldBloc, MyTextFieldState>(
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
        onChanged: (text) => bloc.add(MyTextFieldChangedEvent(text)),
      ),
    );
  }
}
