import 'package:flutter/material.dart';

const primary = Colors.blueAccent;
const secondary = Colors.lightGreen;

// Color Scheme
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF64748B);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF6366F1);
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primary,
  colorScheme: ColorScheme.light(
    primary: primary,
    secondary: secondary,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: AppBarTheme(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondary,
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primary,
  colorScheme: ColorScheme.dark(
    primary: primary,
    secondary: secondary,
    surface: Colors.grey[800]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondary,
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
);
