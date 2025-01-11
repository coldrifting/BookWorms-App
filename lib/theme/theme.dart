import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  //primaryColor: colorBlack,
  fontFamily: "Montserrat",
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 57),
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
    displaySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
  ),
);

extension WhiteTextTheme on TextTheme {
  TextStyle get displaySmallWhite => displaySmall!.copyWith(color: colorWhite);
  TextStyle get headlineLargeWhite => headlineLarge!.copyWith(color: colorWhite);
  TextStyle get headlineSmallWhite => headlineSmall!.copyWith(color: colorWhite);
  TextStyle get headerHeadlineMediumWhite => headlineMedium!.copyWith(color: colorWhite);
  TextStyle get titleMediumWhite => titleMedium!.copyWith(color: colorWhite);
  TextStyle get bodyLargeWhite => bodyLarge!.copyWith(color: colorWhite);
}