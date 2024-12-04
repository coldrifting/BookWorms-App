import 'package:flutter/material.dart';

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
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[800] ?? Colors.black),
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