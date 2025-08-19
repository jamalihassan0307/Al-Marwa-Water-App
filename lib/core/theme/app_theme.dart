import 'package:al_marwa_water_app/core/theme/color_scheme.dart';
import 'package:al_marwa_water_app/core/theme/text_theme.dart';
import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._();

  factory AppTheme() {
    return instance;
  }

  static final AppTheme instance = AppTheme._();

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorSchemeLight,
      textTheme: appTextTheme,
    );
  }
}
