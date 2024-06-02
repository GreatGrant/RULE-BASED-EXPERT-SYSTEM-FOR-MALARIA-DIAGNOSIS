import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    textTheme: appTextTheme(),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.blueGrey[900]!,
        ),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
    indicatorColor: Colors.blueGrey[900],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: Colors.blueGrey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}


TextTheme appTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
  );
}
