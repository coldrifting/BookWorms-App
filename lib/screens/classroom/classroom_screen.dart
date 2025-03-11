import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/models/classroom/student.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/classroom/class_goals_screen.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:bookworms_app/screens/classroom/create_classroom_screen.dart';
import 'package:bookworms_app/screens/classroom/student_view_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:provider/provider.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  late ScrollController _scrollController; // Scroll controller for students list.
  late MenuController _menuController; // Menu controller for the "delete classroom" drop-down menu.
  var selectedIconIndex = 10; // Corresponding to color black.

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          appState.classroom != null
            ? "My Classroom"
            : "Create Classroom", 
          style: TextStyle(color: colorWhite)
        ),
        backgroundColor: colorGreen,
        automaticallyImplyLeading: false,
      ),
      body: appState.classroom != null 
        ? _classroomView(textTheme) 
        : CreateClassroomScreen()
    );
  }

  Widget _classroomView(TextTheme textTheme) {
  AppState appState = Provider.of<AppState>(context);
  Classroom classroom = appState.classroom!;

  return CustomScrollView(
    slivers: [
      // Classroom icon
      SliverStickyHeader(
        header: _classroomHeader(textTheme, classroom)
      ),
          
      // Classroom title and number of students (pinned).
      SliverStickyHeader(
        header: _pinnedClassroomHeader(textTheme, classroom),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Container(
              color: colorGreyLight,
              child: Column(
                children: [
                  addVerticalSpace(8),
                  FractionallySizedBox(
                    widthFactor: 0.4,
                    child: TextButton(
                      onPressed: () => _showClassroomCode(textTheme),
                      style: TextButton.styleFrom(
                        backgroundColor: colorGreen,
                        foregroundColor: colorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("Invite Students"),
                    ),
                  ),
                  addVerticalSpace(8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _studentList(textTheme),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OptionWidget(
                      name: "Class Goals",
                      icon: Icons.data_usage,
                      onTap: () {
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClassGoalsScreen()),
                          );
                        }
                      },
                    ),
                  ),
                  for (Bookshelf bookshelf in classroom.bookshelves) ...[
                    BookshelfWidget(bookshelf: bookshelf),
                    addVerticalSpace(16),
                  ],
                ],
              ),
            ),
          ]),
        )
      ),
    ],
  );
}

  /// Classroom information (icon, name, number of students).
  Widget _classroomHeader(TextTheme textTheme, Classroom classroom) {
    return Container(
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Customizable Classroom icon.
                      Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school,
                            size: 100,
                            color: classroomColors[selectedIconIndex],
                          ),
                        ),
                      ),
                      // Drop down for deleting a classroom.
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _dropDownMenu(textTheme),
                      ),
                      // Pencil edit button.
                      Positioned(
                        top: 70,
                        right: 125,
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
          ],
        ),
      ),
    );
  }

  /// Pinned header---stays static on scroll.
  Widget _pinnedClassroomHeader(TextTheme textTheme, Classroom classroom) {
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border(
          bottom: BorderSide(color: colorGrey),
        ),
      ),
      child: Column(
        children: [
          // Classroom name.
          Text(classroom.classroomName, style: textTheme.headlineMedium, textAlign: TextAlign.center),
          // Number of students text.
          Text(
            "${classroom.students.length} Student${classroom.students.length == 1 ? "" : "s"}",
            style: textTheme.bodyLarge),
          addVerticalSpace(8),
        ],
      ),
    );
  }

  /// The drop down menu for displaying the option to delete the classroom.
  Widget _dropDownMenu(TextTheme textTheme) {
    return MenuAnchor(
      controller: _menuController,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            _menuController.close();
            // Confirm that the user wants to delete the classroom.
            _showDeleteConfirmationDialog(textTheme);
          },
          child: const Text('Delete Classroom'),
        )
      ],
    );
  }

  /// Confirmation dialog to confirm the deletion of the classroom.
  Future<dynamic> _showDeleteConfirmationDialog(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Delete Classroom')),
          content: const Text('Are you sure you want to permanently delete this classroom?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await appState.deleteClassroom();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// The student list widget containing student icons and shortened names.
  Widget _studentList(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    List<Student> students = appState.classroom!.students;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Students", style: textTheme.titleLarge),
          ],
        ),
        addVerticalSpace(8),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: colorGreyDark!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: students.isNotEmpty
          ? ListView.builder(
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
                        onTap: () {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentViewScreen()),
                            );
                          }
                        },
                        // Student icon.
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: UserIcons.getIcon(students[index].profilePictureIndex)),
                      ),
                      addVerticalSpace(4),
                      // Student name.
                      Text(style: textTheme.titleSmall, students[index].name),
                    ],
                  ),
                );
              })
          : const Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "No students in the classroom.\n Use the invite button above!"),
            ),
        ),
      ],
    );
  }

  /// Displays the classroom code in a dialog.
  Future<dynamic> _showClassroomCode(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    String classroomCode = appState.classroom!.classCode;
    classroomCode = "${classroomCode.substring(0, 3)} ${classroomCode.substring(3,6)}";

    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Class Code')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(classroomCode, style: textTheme.headlineMediumGreenDark),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: classroomCode));
              Navigator.pop(context);
            },
            child: Text('COPY', style: textTheme.titleSmall),
          ),
        ],
      ),
    );
  }

  /// Dialog to change the class icon to a specific color.
  Future<dynamic> _changeClassIconDialog(TextTheme textTheme) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Change Classroom Icon')),
        content: _getIconList(),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel', style: textTheme.titleSmall),
          ),
        ],
      ),
    );
  }

  /// The icon list composed of the list of given colors.
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
        itemCount: classroomColors.length,
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
                  color: selectedIconIndex == index
                      ? Colors.grey[400]!
                      : Colors.grey[300]!,
                ),
              ),
              shadowColor: selectedIconIndex == index
                  ? Colors.black
                  : Colors.transparent,
              elevation: selectedIconIndex == index ? 4 : 2,
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Icon(
                  Icons.school,
                  size: 50,
                  color: classroomColors[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
