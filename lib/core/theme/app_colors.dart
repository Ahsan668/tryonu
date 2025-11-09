import 'package:flutter/material.dart';

/// AppColors - Centralized color palette for TryWear AI
/// Change these colors to update the entire app's theme
class AppColors {
  // Primary Colors - Neon Purple-Blue Gradient
  static const primary = Color(0xFF5E5CE6);
  static const primaryDark = Color(0xFF4846C7);
  static const secondary = Color(0xFF8E8DFF);
  static const accent = Color(0xFF00F0FF); // Neon Cyan
  static const accentGlow = Color(0xFF00D9FF);
  
  // Background Colors
  static const backgroundDark = Color(0xFF0F0F1A);
  static const backgroundLight = Color(0xFFF4F6FB);
  static const surfaceDark = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFFFFFFFF);
  
  // Glassmorphism
  static const glassLight = Color(0x40FFFFFF);
  static const glassDark = Color(0x20FFFFFF);
  static const glassBlur = Color(0x10000000);
  
  // Gradient Colors
  static const gradientStart = Color(0xFF5E5CE6);
  static const gradientMiddle = Color(0xFF8E8DFF);
  static const gradientEnd = Color(0xFF00F0FF);
  
  // Text Colors
  static const textPrimaryLight = Color(0xFF1A1A2E);
  static const textSecondaryLight = Color(0xFF6B7280);
  static const textPrimaryDark = Color(0xFFFFFFFF);
  static const textSecondaryDark = Color(0xFFB0B0C3);
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
  
  // Neon Glow Colors
  static const neonPurple = Color(0xFF9D4EDD);
  static const neonBlue = Color(0xFF00D9FF);
  static const neonPink = Color(0xFFFF006E);
  
  // Overlay Colors
  static const overlayLight = Color(0x40000000);
  static const overlayDark = Color(0x60000000);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );
  
  static const darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDark, surfaceDark],
  );
  
  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassLight, glassDark],
  );
  
  static const neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPurple, neonBlue, accent],
  );
}
