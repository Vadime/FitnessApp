import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  // some cached themeMode when loading from storage
  // only for initial state
  static ThemeMode? _themeMode;

  ThemeBloc() : super(_themeMode ?? ThemeMode.system) {
    //when app is started
    on<ThemeSystemEvent>((event, emit) async {
      await setThemeToStorage(ThemeMode.system);
      emit(ThemeMode.system);
    });

    //while switch is clicked
    on<ThemeLightEvent>((event, emit) async {
      await setThemeToStorage(ThemeMode.light);
      emit(ThemeMode.light);
    });

    on<ThemeDarkEvent>((event, emit) async {
      await setThemeToStorage(ThemeMode.dark);
      emit(ThemeMode.dark);
    });
  }

  static Future<ThemeMode> getThemeFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt(_themeModeKey) ?? 0];
    return _themeMode ?? ThemeMode.dark;
  }

  Future<void> setThemeToStorage(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeModeKey, mode.index);
  }

  // map ThemeMode to String
  static Map<ThemeMode, String> get themeModeToString => {
        ThemeMode.light: 'Light',
        ThemeMode.dark: 'Dark',
        ThemeMode.system: 'System',
      };
}
