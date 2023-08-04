abstract class MyTextFieldEvent {
  final String text;
  const MyTextFieldEvent(this.text);
}

class MyTextFieldChangedEvent extends MyTextFieldEvent {
  MyTextFieldChangedEvent(String text) : super(text);
}
