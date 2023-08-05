library widgets;

import 'package:flutter_bloc/flutter_bloc.dart';

part 'text_field_event.dart';
part 'text_field_state.dart';

abstract class TextFieldBloc extends Bloc<TextFieldEvent, TextFieldState> {
  final int minLength;
  final String errorText;
  final String constraints;
  final String? hintText;
  final String? initialValue;
  final bool obscure;

  TextFieldBloc({
    this.initialValue,
    this.minLength = 0,
    required this.hintText,
    required this.errorText,
    required this.constraints,
    this.obscure = false,
  }) : super(
          TextFieldState(
            text: initialValue,
            errorText: null,
            hintText: hintText,
            obscure: obscure,
            autocorrect: false,
            visible: false,
          ),
        ) {
    on<TextFieldEvent>((event, emit) {
      emit(
        TextFieldState(
          text: event.text,
          errorText: _isValid(event.text) ? null : errorText,
          hintText: hintText,
          obscure: obscure,
          autocorrect: false,
          visible: event.visible,
        ),
      );
    });
  }

  bool isValid() {
    return _isValid(state.text ?? '');
  }

  bool _isValid(String data) {
    // check for uppercase
    final bool hasUppercase = data.contains(RegExp(r'[A-Z]'));
    // check for digits
    final bool hasDigits = data.contains(RegExp(r'[0-9]'));
    // check for lowercase
    final bool hasLowercase = data.contains(RegExp(r'[a-z]'));
    // check for special characters
    final bool hasSpecialCharacters = data.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    final bool hasMinLength = data.length > minLength;

    if (constraints.isEmpty) {
      if (hasDigits &
          hasUppercase &
          hasLowercase &
          hasSpecialCharacters &
          hasMinLength) {
        return true;
      } else {
        return false;
      }
    } else {
      if (RegExp(constraints).hasMatch(data)) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class EmailBloc extends TextFieldBloc {
  EmailBloc({initialValue})
      : super(
          initialValue: initialValue,
          hintText: 'Email',
          errorText: 'Email invalid',
          constraints: r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$',
        );
}

class NameBloc extends TextFieldBloc {
  NameBloc({initialValue})
      : super(
          initialValue: initialValue,
          hintText: 'Name',
          errorText: 'Name invalid',
          constraints: r'^(?!$).+',
        );
}

class TextBloc extends TextFieldBloc {
  TextBloc({initialValue, hint})
      : super(
          initialValue: initialValue,
          hintText: hint,
          errorText: hint + ' invalid',
          constraints: r'^(?!$).+',
        );
}

class PasswordBloc extends TextFieldBloc {
  PasswordBloc({String? hintText})
      : super(
          hintText: hintText ?? 'Password',
          minLength: 6,
          obscure: true,
          errorText: 'Password invalid',
          constraints: r'[0-9a-zA-Z]{6}',
        );
}
