import 'package:widgets/controllers/controllers.dart';


/// gibt liste von ausgewählten elementen zurück
class SingleSelectionController<T> extends StateController<T?, T> {
  SingleSelectionController(super.initialState);

  @override
  void toggle(T value) {
    if (state == value) {
      super.emit(null);
    } else {
      super.emit(value);
    }
  }
}
