import 'package:flutter/material.dart';

/// Utility class that provides user-related icons.
class UserIcons {
  /// Returns a user icon based on the [icon] identifier.
  static Widget getIcon(String icon) {
    switch(icon) {
      case 'icon1':
        return const Icon(Icons.person);
    }
    return const Icon(Icons.person_2);
  }
}