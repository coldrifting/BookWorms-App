import 'package:bookworms_app/utils/constants.dart';
import 'package:flutter/material.dart';

/// The [OptionWidget] displays a selectable box with an icon and name.
class OptionWidget extends StatelessWidget {
  final String name;
  final IconData icon;

  const OptionWidget({
    super.key, 
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: COLOR_LGREY,
        border: Border.all(color: COLOR_DGREY ?? COLOR_BLACK),
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
            const SizedBox(width: 16),
            Text(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              name
            ),
          ],
        ),
      ),
    );
  } 
}