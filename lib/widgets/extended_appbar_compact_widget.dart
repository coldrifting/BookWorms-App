import 'package:flutter/material.dart';

import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class ExtendedAppBarCompact extends StatelessWidget {
  final String name;
  final Widget icon;
  final String? username;

  const ExtendedAppBarCompact({
    super.key,
    required this.name,
    required this.icon,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.primary,
        boxShadow: [
          BoxShadow(
            color: context.colors.greyDark.withValues(alpha: 0.4),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addHorizontalSpace(20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                style: textTheme.titleLargeWhite,
                overflow: TextOverflow.ellipsis,
                name,
              ),
              if (username != null) ...[
                Text(style: textTheme.bodyLargeWhite, "@$username"),
                addVerticalSpace(4),
              ]
            ],
          ),
          addHorizontalSpace(20),
          SizedBox(
            width: 75,
            height: 75,
            child: icon,
          )
        ],
      ),
    );
  }
}
