import 'package:flutter/material.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

/// The [OptionWidget] displays a selectable box with an icon and name.
class OptionWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const OptionWidget({
    super.key, 
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: colorGreyLight,
            border: Border.all(color: colorGreyDark ?? colorBlack),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  size: 48,
                  icon
                ),
                addHorizontalSpace(16),
                Text(
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  name
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } 
}