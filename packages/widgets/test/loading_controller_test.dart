import 'package:test/test.dart';
import 'package:widgets/controllers/controllers.dart';

void main() {
  group('LoadingController', () {
    late LoadingController loadingController;

    setUp(() {
      loadingController = LoadingController();
    });

    test('initial state is completed', () {
      expect(loadingController.state.completed, true);
    });

    test('enableInput changes state to not completed', () async {
      loadingController.enableInput();
      expect(loadingController.state.completed, false);
    });

    test('enableInput changes state to completed after delay', () async {
      loadingController.enableInput();
      await Future.delayed(const Duration(seconds: 1));
      expect(loadingController.state.completed, true);
    });

    test('disableInput changes state to value true', () {
      loadingController.disableInput();
      expect(loadingController.state.value, true);
    });
  });
}
