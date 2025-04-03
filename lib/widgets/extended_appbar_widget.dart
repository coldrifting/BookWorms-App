import 'package:flutter/material.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class ExtendedAppBar extends StatelessWidget {
  final String name;
  final Widget icon;
  final String? username;

  const ExtendedAppBar({
    super.key,
    required this.name, 
    required this.icon,
    this.username, 
   });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorGreen,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: icon,
          ),
          addVerticalSpace(10),
          Text(
            style: textTheme.titleLargeWhite,
            overflow: TextOverflow.ellipsis,
            name,
          ),
          if (username != null) ...[
            Text(
              style: textTheme.bodyLargeWhite,
              "@$username"
            ),
            addVerticalSpace(4),
          ]
        ],
      ),
    );
  }
}