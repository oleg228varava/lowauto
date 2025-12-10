import 'package:flutter/material.dart';

class AppThemes {
  // ================== СВІТЛА КОСМІЧНА ТЕМА ==================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4F83CC),
    scaffoldBackgroundColor: const Color(0xFFEAF0FF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F83CC),
      secondary: Color(0xFF7F7FFF),
      background: Color(0xFFEAF0FF),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4F83CC),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.blueAccent.withOpacity(0.2),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F83CC),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFDDE4FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.black45),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF4F83CC),
      unselectedItemColor: Colors.black54,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
  );

  // ================== ТЕМНА КОСМІЧНА ТЕМА ==================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF7F7FFF),
    scaffoldBackgroundColor: const Color(0xFF0A0A20),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7F7FFF),
      secondary: Color(0xFFB38FFF),
      background: Color(0xFF0A0A20),
      surface: Color(0xFF1A1A2E),
      onPrimary: Colors.white,
      onSecondary: Colors.white70,
      onBackground: Colors.white,
      onSurface: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7F7FFF),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A2E),
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7F7FFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white60),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1A2E),
      selectedItemColor: Color(0xFF7F7FFF),
      unselectedItemColor: Colors.white70,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white60),
    ),
  );
}
