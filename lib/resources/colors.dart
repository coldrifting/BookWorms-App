import 'package:flutter/material.dart';

// App Colors
const colorBlack = Colors.black;
const colorGreyDark = Color(0xff616161);
const colorGrey = Colors.grey;
const colorGreyLight = Color(0xFFEEEEEE);
const colorWhite = Colors.white;
const colorYellow = Colors.amber;
const colorGreen = Color(0xff2E7D32);
const colorGreenLight = Color(0xffc1e8c1);
const colorGreenGradTop = Color(0xFF80BC81);
const colorGreenDark = Color(0xff1B5E20);
const colorRed = Color(0xFFD32F2F);

BoxDecoration splashGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(0.8, 1),
      colors: <Color>[
        colorGreenGradTop,
        colorGreenDark,
      ],
    ),
  );
}
