import 'package:test/test.dart';
import 'package:widgets/controllers/controllers.dart';


void main() {
  group('CheckboxController', () {
    late CheckboxController checkboxController;

    setUp(() {
      checkboxController = CheckboxController(false);
    });

    test('initial state is false', () {
      expect(checkboxController.state, false);
    });

    test('invert toggles state', () {
      checkboxController.invert();
      expect(checkboxController.state, true);
      checkboxController.invert();
      expect(checkboxController.state, false);
    });
  });
}
