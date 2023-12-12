import 'package:widgets/controllers/controllers.dart';


/// gibt liste von ausgewählten elementen zurück
class MultiSelectionController<T> extends StateController<List<T>, T> {
  MultiSelectionController(super.initialState);

  @override
  void toggle(T value) {
    var state = List<T>.from(this.state);
    if (state.contains(value)) {
      super.emit(state..remove(value));
    } else {
      super.emit(state..add(value));
    }
  }
}
