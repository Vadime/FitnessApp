part of 'text_field_bloc.dart';

class TextFieldState {
  final String? text;
  final String? errorText;
  final String? hintText;

  final bool obscure;
  final bool autocorrect;

  bool visible;

  TextFieldState({
    required this.text,
    required this.errorText,
    required this.hintText,
    required this.obscure,
    required this.autocorrect,
    this.visible = false,
  });
}
