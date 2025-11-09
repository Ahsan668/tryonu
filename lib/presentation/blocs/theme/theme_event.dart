import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  
  @override
  List<Object?> get props => [];
}

/// Toggle theme mode
class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

/// Set specific theme mode
class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  
  const ThemeChanged({required this.themeMode});
  
  @override
  List<Object?> get props => [themeMode];
}

/// Load theme from storage
class ThemeLoadRequested extends ThemeEvent {
  const ThemeLoadRequested();
}
