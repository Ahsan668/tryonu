import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// ThemeBloc - Handles theme mode management with persistence
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _prefs;
  
  ThemeBloc({required SharedPreferences prefs})
      : _prefs = prefs,
        super(ThemeState.initial()) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoadRequested>(_onLoadTheme);
  }
  
  /// Toggle between light and dark mode
  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    
    await _saveThemeMode(newMode);
    emit(state.copyWith(themeMode: newMode));
  }
  
  /// Change to specific theme mode
  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }
  
  /// Load theme from storage
  Future<void> _onLoadTheme(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeIndex = _prefs.getInt(AppConstants.themeKey);
    
    if (savedThemeIndex != null) {
      final themeMode = ThemeMode.values[savedThemeIndex];
      emit(state.copyWith(themeMode: themeMode));
    }
  }
  
  /// Save theme mode to storage
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await _prefs.setInt(AppConstants.themeKey, mode.index);
  }
}
