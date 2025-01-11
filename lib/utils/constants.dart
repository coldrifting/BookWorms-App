import 'package:flutter/material.dart';

// App Colors
const colorBlack = Colors.black;
final colorGreyDark = Colors.grey[700];
const colorGrey = Colors.grey;
final colorGreyLight = Colors.grey[200];
const colorWhite = Colors.white;
const colorYellow = Colors.amber;
final colorGreen = Colors.green[800];

// Text style
const TextTheme textThemeDefault = TextTheme(
    headlineLarge: TextStyle(
        color: colorBlack, fontWeight: FontWeight.w700, fontSize: 32),
    headlineMedium: TextStyle(
        color: colorWhite, fontWeight: FontWeight.w700, fontSize: 28),
    headlineSmall: TextStyle(
        color: colorBlack, fontWeight: FontWeight.w700, fontSize: 24),
    titleLarge: TextStyle(
        color: colorBlack, fontWeight: FontWeight.w700, fontSize: 20),
    titleMedium: TextStyle(
        color: colorBlack, fontWeight: FontWeight.w700, fontSize: 16),
    titleSmall: TextStyle(
        color: colorWhite, fontSize: 14),
    bodyLarge: TextStyle(
        color: colorBlack, fontSize: 14, fontWeight: FontWeight.w500,height: 1.5),
    bodyMedium: TextStyle(
        color:  colorGrey, fontSize: 14, fontWeight: FontWeight.w500,height: 1.5),
    // subtitle1:
    //     TextStyle(color: COLOR_BLACK, fontSize: 12, fontWeight: FontWeight.w400),
    // subtitle2: TextStyle(
    //     color: COLOR_GREY, fontSize: 12, fontWeight: FontWeight.w400)
);