import 'package:bookworms_app/demo_books.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/bookshelf_widget.dart';

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
      body: ListView(
        children: [
          Padding(
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
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: colorGreen,
                    foregroundColor: colorWhite,
                  ),
                  child: const Text("Invite Students")
                ),
                _studentList(textTheme),
              ],
            ),
          ),
          addVerticalSpace(8),
          BookshelfWidget(name: "Assigned Reading", images: const [Demo.image8, Demo.image9, Demo.image7, Demo.image10], books: [Demo.book8, Demo.book9, Demo.book7, Demo.book10]),
          addVerticalSpace(8),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: OptionWidget(name: "Class Goals", icon: Icons.data_usage),
          )
        ],
      ),
    );
  }

  Widget _studentList(TextTheme textTheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Students", 
              style: textTheme.titleLarge
            ),
            TextButton(
              onPressed: () {}, 
              child: const Icon(Icons.more_horiz)
            ),
          ],
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: colorGreyLight,
            border: Border.all(color: colorGreyDark ?? colorBlack),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}