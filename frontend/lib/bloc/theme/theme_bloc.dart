import 'package:bloc/bloc.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';

class ThemeEvent {
  final ThemeMode mode;
  const ThemeEvent({
    required this.mode,
  });
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.dark) {
    on<ThemeEvent>((event, emit) async {
      UserRepository.updateThemeMode(event.mode);
      emit(event.mode);
    });
    UserRepository.getThemeMode().then((mode) => add(ThemeEvent(mode: mode)));
  }
}
