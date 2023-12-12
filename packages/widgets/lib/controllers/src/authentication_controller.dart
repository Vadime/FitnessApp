import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/utils/utils.dart';

class AuthenticationController extends Cubit<bool> {
  
  AuthenticationController._internal() : super(false);
  static final AuthenticationController _instance =
      AuthenticationController._internal();
  factory AuthenticationController() => _instance;

  void login() => emit(true);

  void logout() => emit(false);

  @override
  void onChange(Change<bool> change) {
    super.onChange(change);
    Logging.logDetails('AuthenticationController', change);
  }
}
