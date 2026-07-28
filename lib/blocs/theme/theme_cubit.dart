// lib/bloc/theme/theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> toggleTheme() async {
    final newIsDarkMode = !state.isDarkMode;
    await _saveTheme(newIsDarkMode);
    emit(state.copyWith(isDarkMode: newIsDarkMode));
  }

  Future<void> setTheme(bool isDark) async {
    await _saveTheme(isDark);
    emit(state.copyWith(isDarkMode: isDark));
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
