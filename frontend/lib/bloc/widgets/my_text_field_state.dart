abstract class MyTextFieldState {
  final String? errorText;
  final String? text;
  MyTextFieldState(this.text, {this.errorText});
}

class MyTextFieldNormalState extends MyTextFieldState {
  MyTextFieldNormalState(text) : super(text);
}

class MyTextFieldErrorState extends MyTextFieldState {
  MyTextFieldErrorState(text, errorText) : super(text, errorText: errorText);
}
