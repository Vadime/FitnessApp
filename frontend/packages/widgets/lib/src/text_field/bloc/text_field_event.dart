part of 'text_field_bloc.dart';

abstract class TextFieldEvent {
  final String text;
  const TextFieldEvent(this.text);
}

class TextFieldChangedEvent extends TextFieldEvent {
  TextFieldChangedEvent(String text) : super(text);
}
