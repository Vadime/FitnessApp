part of 'text_field_bloc.dart';

abstract class TextFieldState {
  final String? errorText;
  final String? text;
  TextFieldState(this.text, {this.errorText});
}

class TextFieldNormalState extends TextFieldState {
  TextFieldNormalState(text) : super(text);
}

class TextFieldErrorState extends TextFieldState {
  TextFieldErrorState(text, errorText) : super(text, errorText: errorText);
}
