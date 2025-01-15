import 'package:bookworms_app/demo_books.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
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
  late ScrollController _scrollController;

  // Temporary until we have real child data.
  List<String> students = ["Annie C.", "Henry B.", "Lucas G.", "Prim R.", "Winnie S."];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }


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
                              onPressed: () => _deleteClassroom(), 
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
                  "${students.length} Student${students.length == 1 ? "" : "s"}",
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
          height: 160,
          decoration: BoxDecoration(
            color: colorGreyLight,
            border: Border.all(color: colorGreyDark ?? colorBlack),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: students.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: UserIcons.getIcon("")
                        ),
                      ),
                      addVerticalSpace(4),
                      Text(
                        style: textTheme.titleSmall,
                        students[index]
                      ),
                    ],
                 ),
              );
            }
          ),
        ),
      ],
    );
  }

  void _deleteClassroom() {
    
  }
}