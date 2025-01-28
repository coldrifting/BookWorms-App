import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class ExtendedAppBar extends StatelessWidget {
  final String name;
  final String username;
  final Widget icon;

  const ExtendedAppBar({
    super.key,
    required this.name, 
    required this.username, 
    required this.icon
   });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorGreen,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.4),
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
          addVerticalSpace(4),
          Text(
            style: textTheme.titleLargeWhite,
            name,
          ),
          Text(
            style: textTheme.bodyLargeWhite,
            "@$username"
          ),
          addVerticalSpace(4),
        ],
      ),
    );
  }
}