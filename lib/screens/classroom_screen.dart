import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Johnny's Bookshelves", style: TextStyle(color: colorWhite)),
        backgroundColor: colorGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        size: 100,
                        Icons.school
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: TextButton(
                          onPressed: () {}, 
                          child: const Icon(Icons.more_horiz)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Ms. Wilson's Class",
              style: textTheme.headlineMedium
            ), 
            Text(
              "0 Students",
              style: textTheme.bodyLarge
            ),
            addVerticalSpace(8),
            const Divider(thickness: 2,),
          ],
        ),
      ),
    );
  }
}