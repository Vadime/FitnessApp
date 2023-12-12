import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/utils/utils.dart';


class TextFieldController extends TextEditingController {
  final String? labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  RegExp? errorRegex;
  String? errorText;
  late bool visible;
  final List<TextInputFormatter>? inputFormatters;
  String? _extraError;
  bool Function(String text)? extraValidator;

  TextFieldController(
    this.labelText, {
    this.errorRegex,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
    this.extraValidator,
    super.text,
  }) {
    visible = obscureText;
  }

  // email congiuration
  factory TextFieldController.email({
    String? labelText = 'Email',
    String? errorText = 'Invalid email',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r'^[\w\.-]+@[a-zA-ZäßüöÄÜÖ\d\.-]+\.[a-zA-Z]{2,}$'),
        errorText: errorText,
        keyboardType: TextInputType.emailAddress,
        text: text,
      );

  // password congiuration
  factory TextFieldController.password({
    String? labelText = 'Password',
    String? errorText = 'Invalid password',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r'[0-9a-zA-ZäßüöÄÜÖ]{6}'),
        errorText: errorText,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        text: text,
      );

  // name congiuration
  factory TextFieldController.name({
    String? labelText = 'Name',
    String? errorText = 'Invalid name',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r"^[a-zA-ZäßüöÄÜÖ\s'-]+$", unicode: true),
        errorText: errorText,
        keyboardType: TextInputType.name,
        text: text,
      );

  // phone congiuration
  factory TextFieldController.phone({
    String? labelText = 'Phone',
    String? errorText = 'Invalid phone',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r'^[0-9\s\-\(\)+-]+$'),
        errorText: errorText,
        keyboardType: TextInputType.phone,
        text: text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(16),
        ],
      );

  // one number congiuration
  factory TextFieldController.number({
    String? labelText = 'Number',
    String? errorText = 'Invalid number',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r'^[0-9]+$'),
        errorText: errorText,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        text: text,
      );
  // code congiuration
  factory TextFieldController.code({
    String? labelText = 'Code',
    String? errorText = 'Invalid code',
    String? text,
  }) =>
      TextFieldController(
        labelText,
        errorRegex: RegExp(r'^[0-9]*$'),
        errorText: errorText,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        text: text,
      );

  // iban congiuration
  factory TextFieldController.iban({
    String? labelText = 'IBAN',
    String? errorText = 'Invalid IBAN',
    String? text = 'DE',
  }) => TextFieldController(
      labelText,
      errorRegex: RegExp(r'^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{1,30}$'),
      errorText: errorText,
      keyboardType: TextInputType.text,
      text: text,
      extraValidator: isValidGermanIBAN,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\s]')),
        LengthLimitingTextInputFormatter(27),
        IbanFormatter(),
      ],
    );

  String? calcErrorText(bool allowEmpty) {
    if (_extraError != null) {
      if (!isValid(allowEmpty: allowEmpty)) {
        return errorText;
      }
      return _extraError;
    }
    if (isValid(allowEmpty: allowEmpty)) {
      return null;
    } else {
      return errorText;
    }
  }

  bool isValid({bool allowEmpty = false}) {
    var finalAllowEmpty = allowEmpty ? text.isNotEmpty : text.isEmpty;
    if (errorRegex != null && finalAllowEmpty) {
      return errorRegex!.hasMatch(text);
    }
    var again = !allowEmpty ? (extraValidator?.call(text) ?? true) : true;
    return again;
  }

  setError(String? error) {
    _extraError = error;
    notifyListeners();
  }

  @override
  String toString() {
    return 'TextFieldController{labelText: $labelText, keyboardType: $keyboardType, obscureText: $obscureText, errorRegex: $errorRegex, errorText: $errorText, visible: $visible, inputFormatters: $inputFormatters, _extraError: $_extraError}';
  }
}

bool isValidGermanIBAN(String iban) {
  // Remove spaces and convert to uppercase
  iban = iban.replaceAll(' ', '').toUpperCase();
  // Check if the length is 22 characters
  if (iban.length != 22) {
    return false;
  }

  // Verify the country code
  if (iban.substring(0, 2) != 'DE') {
    return false;
  }

  // Verify that the remaining characters are digits
  if (!iban.substring(2).contains(RegExp(r'^[0-9]*$'))) {
    return false;
  }

  // Perform IBAN checksum validation

  // Step 1: Rearrange the IBAN
  String rearrangedIBAN = iban.substring(4) + iban.substring(0, 4);

  // Step 2: Replace letters with numeric values
  String numericIBAN = '';
  for (int i = 0; i < rearrangedIBAN.length; i++) {
    final char = rearrangedIBAN[i];
    if (char.compareTo('0') >= 0 && char.compareTo('9') <= 0) {
      numericIBAN += char;
    } else {
      numericIBAN += (char.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10).toString();
    }
  }

  // Step 3: Calculate the remainder
  final countryCodeDigits = numericIBAN;
  final remainder = BigInt.parse(countryCodeDigits) % BigInt.from(97);

  // Step 4: Check if the remainder is 1
  return remainder == BigInt.one;
}
