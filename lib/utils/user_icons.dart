import 'package:flutter/material.dart';

/// Utility class that provides user-related icons.
class UserIcons {
  /// Returns a user icon based on the [icon] identifier.
  static Widget getIcon(int index) {
    return CircleAvatar(backgroundImage: AssetImage("assets/images/user_icon$index.jpg"));
  }
}