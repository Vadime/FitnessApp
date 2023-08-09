import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginState initialState;
  LoginBloc({required this.initialState}) : super(initialState) {
    on<LoginSignInEvent>((event, emit) => emit(LoginSignInState()));
    on<LoginSignUpEvent>((event, emit) => emit(LoginSignUpState()));
    on<LoginSendPasswordEvent>((event, emit) => emit(LoginSendPasswordState()));
  }
}
