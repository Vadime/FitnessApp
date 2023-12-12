import 'package:widgets/controllers/controllers.dart';


class SegmentedButtonController<T> extends StateController<T, T> {
  SegmentedButtonController(super.initialState);

  @override
  void toggle(T value) => super.emit(value);
}
