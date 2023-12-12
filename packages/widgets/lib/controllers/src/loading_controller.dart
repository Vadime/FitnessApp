import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/utils/utils.dart';

import 'package:widgets/models/models.dart';

class LoadingController extends Cubit<AnimatedBool> {
  static final LoadingController _singleton = LoadingController._internal();
  LoadingController._internal()
      : super(const AnimatedBool(value: false, completed: true));
  factory LoadingController() => _singleton;

  void enableInput() {
    emit(const AnimatedBool(value: false, completed: false));
    Future.delayed(const Duration(seconds: 1), () {
      emit(const AnimatedBool(value: false, completed: true));
    });
  }

  void disableInput() {
    emit(const AnimatedBool(value: true, completed: true));
  }

  @override
  void onChange(Change<AnimatedBool> change) {
    super.onChange(change);
    Logging.logDetails('LoadingController', change);
  }

  loadingProcess(Function()? onWait) async {
    try {
      LoadingController().disableInput();
      await onWait?.call();
    } catch (e, s) {
      Logging.logDetails('Error in loading process', e, s);
    } finally {
      LoadingController().enableInput();
    }
  }
}
