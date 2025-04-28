import 'package:flutter/material.dart';

const textColor = Color(0xFF0a0303);
const backgroundColor = Color(0xFFfefbfb);
const primaryColor = Color(0xFF1d1d1d);
const primaryFgColor = Color(0xFFfefbfb);
const secondaryColor = Color(0xFF8ddc8a);
const secondaryFgColor = Color(0xFF0a0303);
const accentColor = Color(0xFF68d1b0);
const accentFgColor = Color(0xFF0a0303);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error:
      Brightness.light == Brightness.light
          ? Color(0xffB3261E)
          : Color(0xffF2B8B5),
  onError:
      Brightness.light == Brightness.light
          ? Color(0xffFFFFFF)
          : Color(0xff601410),
);
