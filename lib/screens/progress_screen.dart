import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:flutter/material.dart';

/// The [ProgressScreen] contains information about the selected child's
/// progress toward their set custom goals.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

/// The state of the [ProgressScreen].
class _ProgressScreenState extends State<ProgressScreen> { 
  @override
  Widget build(BuildContext context) { 
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Johnny's Progress", style: TextStyle(color: colorWhite)),
        backgroundColor: colorGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: UserIcons.getIcon("")
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                    "Johnny"
                  ),
                  const Icon(
                    size: 35,
                    Icons.arrow_drop_down_sharp
                  ),
                ],
              ),
            ),
            Text(
              style: textTheme.bodyLarge,
              "Reading Level: A"
            ),
            const Divider(),
            addVerticalSpace(10),
            const OptionWidget(name: "Overall Progress", icon: Icons.auto_stories),
            addVerticalSpace(16),
            const OptionWidget(name: "Goal Progress", icon: Icons.grass_sharp),
          ],
        ),
      ),
    );
  }
}