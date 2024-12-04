import 'package:flutter/material.dart';

class UserIcons {
  static Widget getIcon(String icon) {
    switch(icon) {
      case 'icon1':
        return const Icon(Icons.person);
    }
    return const Icon(Icons.person_2);
  }
}