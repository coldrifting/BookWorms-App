import 'package:bookworms_app/icons/user_icons.dart';
import 'package:bookworms_app/utils/constants.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Johnny's Progress", style: TextStyle(color: COLOR_WHITE)),
        backgroundColor: COLOR_GREEN,
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
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    "Johnny"
                  ),
                  Icon(
                    size: 35,
                    Icons.arrow_drop_down_sharp
                  ),
                ],
              ),
            ),
            const Text(
              style: TextStyle(fontSize: 16),
              "Reading Level: A"
            ),
            const Divider(),
            const SizedBox(height: 10),
            const OptionWidget(name: "Overall Progress", icon: Icons.auto_stories),
            const SizedBox(height: 16),
            const OptionWidget(name: "Goal Progress", icon: Icons.grass_sharp),
          ],
        ),
      ),
    );
  }
}