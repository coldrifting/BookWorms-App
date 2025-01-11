import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: colorBlack,
  fontFamily: "Montserrat",
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
    headlineMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    titleSmall: TextStyle(fontSize: 14),
    bodyLarge: TextStyle(fontSize: 18, height: 1.5),
    bodyMedium: TextStyle(fontSize: 16, height: 1.5),
  ),
);

extension WhiteTextTheme on TextTheme {
  TextStyle get headlineLargeWhite => headlineLarge!.copyWith(color: colorWhite);
  TextStyle get headerHeadlineMediumWhite => headlineMedium!.copyWith(color: colorWhite);
  TextStyle get titleMediumWhite => titleMedium!.copyWith(color: colorWhite);
  TextStyle get bodyLargeWhite => bodyLarge!.copyWith(color: colorWhite);
}