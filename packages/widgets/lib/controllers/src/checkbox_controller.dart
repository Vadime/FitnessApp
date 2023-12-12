import 'package:widgets/controllers/controllers.dart';

class CheckboxController extends StateController<bool, bool?> {
  CheckboxController(super.initialState);

  void invert() => toggle(!state);

  @override
  void toggle(bool? value) => super.emit(value ?? false);
}
