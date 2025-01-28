import 'package:flutter/material.dart';
import 'dart:math';

/// Utility class that provides user-related icons.
class UserIcons {
  static const numIcons = 9;

  /// Returns a user icon based on the [icon] identifier.
  static Widget getIcon(int index) {
    return CircleAvatar(backgroundImage: AssetImage("assets/images/user_icon$index.jpg"));
  }

  /// Returns a random icon index.
  static Widget getRandomIcon() {
    int index = Random().nextInt(numIcons);
    return getIcon(index);
  }
} 