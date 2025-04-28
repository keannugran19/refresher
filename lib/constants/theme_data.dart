import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';

class ThemeClass {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    // global colors around the app
    colorScheme: colorScheme,
    // font used by the app
    fontFamily: 'Poppins',
    // theme of text
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: textColor,
      ), // Adjusting the text color globally
      bodyMedium: TextStyle(color: textColor),
      bodySmall: TextStyle(color: textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Button text color
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(accentColor),
      ),
    ),
    scaffoldBackgroundColor:
        backgroundColor, // Set the background color for the app
    iconTheme: const IconThemeData(
      color: accentColor, // Set the icon color
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
    ),
  );
}

ThemeClass themeClass = ThemeClass();
