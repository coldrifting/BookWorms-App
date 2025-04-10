import 'package:flutter/material.dart';

// App Colors
const colorBlack = Colors.black;
const colorGreyDark = Color(0xff616161);
const colorGrey = Colors.grey;
const colorGreyLight = Color(0xFFEEEEEE);
const colorWhite = Colors.white;
const colorAmber = Colors.amber;
const colorGreen = Color(0xff2E7D32);
const colorGreenLight = Color(0xffc1e8c1);
const colorGreenLessLight = Color(0xFF97D198);
const colorGreenLessDark = Color(0xFF80BC81);
const colorGreenDark = Color(0xff1B5E20);
const colorRed = Color(0xFFD32F2F);
const colorBlue = Color(0xFF7D8DB3);
const colorBlueLight = Color(0xFFAEBFE8);
const colorBlueLightest = Color(0xFFBBCBF2);
const colorBlueDark = Color(0xFF566587);
const colorPink = Color.fromARGB(255, 7, 1, 4);
const colorPinkLight = Color(0xFFD49FB4);
const colorPinkLightest = Color(0xFFDEB4C4);
const colorPinkDark = Color(0xFF9C5D77);
const colorBrown = Color(0xFFB3A37D);
const colorBrownLight = Color(0xFFCFC09F);
const colorBrownLightest = Color(0xFFD9CDB0);
const colorBrownDark = Color(0xFF9C8B64);
const colorYellow = Color(0xFFE6A939);
const colorYellowLight = Color(0xFFF5BF5D);
const colorYellowDark = Color(0xFFD49420);

BoxDecoration splashGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(0.8, 1),
      colors: <Color>[
        colorGreenLessDark,
        colorGreenDark,
      ],
    ),
  );
}
