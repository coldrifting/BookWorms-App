import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';

// Creates a SizedBox widget with specified height.
Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

// Creates a SizedBox widget with specified width.
Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Future<void> pushScreen(context, screen, {replace = false, root = false}) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) => screen);

  if (replace) {
    return Navigator.of(context, rootNavigator: root).pushReplacement(route);
  }
  else {
    return Navigator.of(context, rootNavigator: root).push(route);
  }
}

// Returns the first 'count' of authors stylistically.
String printFirstAuthors(var authorList, int count) {
  var authors = authorList.take(count);
  return authors.length < count
    ? authors.join(", ")
    : "${authors.join(", ")}, and more";
}

SystemUiOverlayStyle defaultOverlay([Color? color, bool light = true]) {
  return SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: color ?? colorGreen,

    // Status bar icon brightness
    // For Android
    statusBarIconBrightness: light == true ? Brightness.light : Brightness.dark,

    // For iOS
    statusBarBrightness:  light == true ? Brightness.light : Brightness.dark,
  );
}
