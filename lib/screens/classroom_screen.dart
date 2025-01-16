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
  var selectedIconIndex = 10; // Corresponding to color black.

  // Temporary until we have real child data.
  List<String> students = ["Annie C.", "Henry B.", "Lucas G.", "Prim R.", "Winnie S."];

  // Defined for the choice of class icon.
  final List<Color> _colors = [
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.lightGreen,
      Colors.green,
      Colors.lightBlue,
      Colors.blue,
      Colors.purple,
      Colors.brown,
      Colors.black
    ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Classroom", style: TextStyle(color: colorWhite)),
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
                            Icon(
                              size: 100,
                              Icons.school,
                              color: _colors[selectedIconIndex],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: TextButton(
                                onPressed: () => _deleteClassroom(), 
                                child: const Icon(Icons.more_horiz)
                              ),
                            ),
                            Positioned(
                              top: 55,
                              right: 130,
                              child: RawMaterialButton(
                                onPressed: () => _changeClassIconDialog(textTheme),
                                fillColor: colorWhite,
                                constraints: const BoxConstraints(minWidth: 0.0),
                                padding: const EdgeInsets.all(5.0),
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.mode_edit_outline_sharp,
                                  size: 15,
                                ),
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
                  const Divider(thickness: 2),
                  FractionallySizedBox(
                    widthFactor: 0.4,
                    child: TextButton(
                      onPressed: () => _showClassroomCode(textTheme),
                      style: TextButton.styleFrom(
                        backgroundColor: colorGreenDark,
                        foregroundColor: colorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("Invite Students")
                    ),
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

  Future<dynamic> _showClassroomCode(TextTheme textTheme) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Class Code')),
          content: Text(
            "XXX XXX",
            style: textTheme.headlineMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: textTheme.titleSmall
              ),
            ),
          ],
        ),
    );
  }

  Future<dynamic> _changeClassIconDialog(TextTheme textTheme) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Change Classroom Icon')),
          content: _getIconList(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: textTheme.titleSmall
              ),
            ),
          ],
        ),
    );
  }

  Widget _getIconList() {
    return SizedBox(
        width: double.maxFinite,
        height: 400,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Change selected color and exit popup.
                setState(() {
                  selectedIconIndex = index;
                });
                Navigator.of(context).pop();
              },
              child: Material(
                shape: CircleBorder(
                  side: BorderSide(
                    color: selectedIconIndex == index ? Colors.grey[400]! : Colors.grey[300]!,
                  ),
                ),
                shadowColor: selectedIconIndex == index ? Colors.black : Colors.transparent,
                elevation: selectedIconIndex == index ? 4 : 2,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Icon(
                    Icons.school,
                    size: 50,
                    color: _colors[index],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}