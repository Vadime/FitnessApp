import 'package:flutter_test/flutter_test.dart';
import 'package:widgets/controllers/controllers.dart';

void main() {
  group('AuthenticationController', () {
    late AuthenticationController authenticationController;

    setUp(() {
      authenticationController = AuthenticationController();
    });

    test('initial state is false', () {
      expect(authenticationController.state, false);
    });

    test('login changes state to true', () {
      authenticationController.login();
      expect(authenticationController.state, true);
    });

    test('logout changes state to false', () {
      authenticationController.logout();
      expect(authenticationController.state, false);
    });
  });
}
