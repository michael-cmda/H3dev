import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE5E6EF),
  100: Color(0xFFBDC1D7),
  200: Color(0xFF9298BD),
  300: Color(0xFF666FA2),
  400: Color(0xFF45508E),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF202C72),
  700: Color(0xFF1B2567),
  800: Color(0xFF161F5D),
  900: Color(0xFF0D134A),
});
const int _primaryPrimaryValue = 0xFF24317A;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF828BFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFF1C2DFF),
  700: Color(0xFF0316FF),
});
const int _primaryAccentValue = 0xFF4F5CFF;
