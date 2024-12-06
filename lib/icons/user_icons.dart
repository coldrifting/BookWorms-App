import 'dart:math';

import 'package:flutter/material.dart';

/// Utility class that provides user-related icons.
class UserIcons {
  /// Returns a user icon based on the [icon] identifier.
  /// Temporarily picks a random icon.
  static Widget getIcon(String icon) {
    var intVal = Random().nextInt(4) + 1;
    return CircleAvatar(backgroundImage: AssetImage("assets/images/user_icon$intVal.jpg"));
  }
}