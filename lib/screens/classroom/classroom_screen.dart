import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Temporary until we have real child data.
  List<String> students = [
    "Annie C.",
    "Henry B.",
    "Lucas G.",
    "Prim R.",
    "Winnie S."
  ];

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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Classroom information (icon, name, number of students).
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Customizable Classroom icon.
                        Icon(
                          size: 100,
                          Icons.school,
                          color: _colors[selectedIconIndex],
                        ),
                        // Drop down for deleting a classroom.
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _dropDownMenu(textTheme),
                        ),
                        // Pencil edit button.
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
              // Classroom name.
              Text(appState.classroom!.classroomName, style: textTheme.headlineMedium),
              // Number of students text.
              Text(
                "${students.length} Student${students.length == 1 ? "" : "s"}",
                style: textTheme.bodyLarge),
              addVerticalSpace(8),
              const Divider(thickness: 2),
              // "Invite Students" button.
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
        // Classroom bookshelves.
        for (Bookshelf bookshelf in appState.classroom!.bookshelves) ...[
          BookshelfWidget(bookshelf: bookshelf),
          addVerticalSpace(8),
        ],
        addVerticalSpace(8),
        // Class goals container --> Mock data.
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OptionWidget(
            name: "Class Goals",
            icon: Icons.data_usage,
            onTap: () {},
          ),
        )
      ],
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

  /// Resets the state of the old classroom.
  // void _deleteClassroom() async {
  //   AppState appState = Provider.of<AppState>(context, listen: false);
  //   var success = await appState.deleteClassroom();
  //   // Navigate to the "Create Classroom Screen".
  //   // if (success && mounted) {
  //   //   Navigator.push(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //       builder: (context) => const CreateClassroomScreen(),
  //   //     ),
  //   //   );
  //   // }
  // }

  /// The student list widget containing student icons and shortened names.
  Widget _studentList(TextTheme textTheme) {
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
            color: colorGreyLight,
            border: Border.all(color: colorGreyDark ?? colorBlack),
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
                                    builder: (context) =>
                                        const StudentViewScreen(),
                                  ),
                                );
                              }
                            },
                            // Student icon.
                            child: SizedBox(
                                width: 90,
                                height: 90,
                                child: UserIcons.getRandomIcon()),
                          ),
                          addVerticalSpace(4),
                          // Student name.
                          Text(style: textTheme.titleSmall, students[index]),
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
    String classroomCode = "XXX XXX";

    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Class Code')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                classroomCode,
                style: textTheme.headlineMediumGreenDark,
              ),
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
