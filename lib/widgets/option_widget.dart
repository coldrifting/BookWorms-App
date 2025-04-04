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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: colorBlack,
        backgroundColor: colorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: BorderSide(color: colorGreyDark),
        padding: EdgeInsets.all(16.0),
      ),
      child: Row(
        children: [
          Icon(size: 48, icon, color: colorBlack),
          addHorizontalSpace(16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
        ],
      )
    );
  } 
}