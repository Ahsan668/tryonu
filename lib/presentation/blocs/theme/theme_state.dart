import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme State
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  
  const ThemeState({required this.themeMode});
  
  /// Initial theme (system default)
  factory ThemeState.initial() {
    return const ThemeState(themeMode: ThemeMode.system);
  }
  
  /// Copy with method
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
  
  @override
  List<Object?> get props => [themeMode];
}
