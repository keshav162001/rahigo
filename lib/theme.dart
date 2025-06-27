import 'package:flutter/material.dart';

final ThemeData rahiTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Georgia', // Optional: adds a traditional serif feel
  scaffoldBackgroundColor: Color(0xFF1E1E1E), // Deep charcoal

  colorScheme: ColorScheme.dark(
    primary: Color(0xFFB68D40), // Royal gold
    secondary: Color(0xFF8B2E28), // Maroon red
    surface: Color(0xFF2C2C2C),
    background: Color(0xFF1E1E1E),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white70,
    error: Colors.redAccent,
    onError: Colors.white,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF8B2E28), // Maroon
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white12,
    hintStyle: TextStyle(color: Colors.white60),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFB68D40)),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFB68D40), // Gold
      foregroundColor: Colors.black,
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
