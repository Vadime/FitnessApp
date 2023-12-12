import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/models/models.dart';
import 'package:widgets/utils/utils.dart';

class ToastData {
  final dynamic message;
  final AnimatedBool animation;

  const ToastData(this.message, this.animation);
}

class ToastController extends Cubit<ToastData> {
  static final ToastController _singleton = ToastController._internal();
  ToastController._internal()
      : super(
            const ToastData(null, AnimatedBool(value: false, completed: true)));
  factory ToastController() => _singleton;

  static Duration get showTime => const Duration(seconds: 2);
  static Duration get animTime => const Duration(milliseconds: 200);

  Future<void> add(dynamic message) async {
    emit(ToastData(message, const AnimatedBool(value: true, completed: false)));
    await Future.delayed(animTime);
    emit(ToastData(message, const AnimatedBool(value: true, completed: true)));
  }

  Future<void> show(dynamic message) async {
    Logging.log(message);
    await add(message);
    await Future.delayed(showTime);
    await remove(message);
  }

  Future<void> remove(dynamic message) async {
    emit(
        ToastData(message, const AnimatedBool(value: false, completed: false)));
    await Future.delayed(animTime);
    emit(ToastData(message, const AnimatedBool(value: false, completed: true)));
  }

  @override
  void onChange(Change<ToastData> change) {
    super.onChange(change);
    Logging.logDetails('LoadingController', change);
  }
}
