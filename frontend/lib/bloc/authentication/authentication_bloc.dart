import 'package:equatable/equatable.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<_AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const UserUnauthenticatedState()) {
    on<_UserAuthenticatedEvent>(
      (event, emit) {
        emit(const UserAuthenticatedState());
      },
    );
    on<_UserUnauthenticatedEvent>(
      (event, emit) {
        emit(const UserUnauthenticatedState());
      },
    );
    UserRepository.authStateChanges.listen((User? user) async {
      if (user == null) {
        add(const _UserUnauthenticatedEvent());
      } else {
        await UserRepository.refreshUserRole();
        add(const _UserAuthenticatedEvent());
      }
    });
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    Logging.log('AuthenticationBloc $change');
  }
}
