import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/classroom/class_bookshelves_tab.dart';
import 'package:bookworms_app/screens/classroom/class_students_tab.dart';
import 'package:bookworms_app/screens/goals/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/screens/classroom/create_classroom_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:provider/provider.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  late MenuController _menuController; // Menu controller for the "delete classroom" drop-down menu.
  late int selectedIconIndex;

  @override
  void initState() {
    super.initState();
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

    // Set the classroom icon.
    selectedIconIndex = appState.classroom!.classIcon;

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Classroom header.
          SliverToBoxAdapter(child: _classroomHeader(textTheme, classroom)),

          // Pinned classroom header.
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SliverDelegate(
              child: _pinnedClassroomHeader(textTheme, classroom),
            ),
          ),

          // Pinned TabBar.
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SliverDelegate(
              child: TabBar(
                labelColor: colorGreen,
                unselectedLabelColor: Colors.grey,
                indicatorColor: colorGreen,
                tabs: const [
                  Tab(icon: Icon(Icons.groups), text: "Students"),
                  Tab(icon: Icon(Icons.insert_chart_outlined_sharp), text: "Goals"),
                  Tab(icon: Icon(Icons.collections_bookmark_rounded), text: "Bookshelves"),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            StudentsScreen(),
            GoalsScreen(),
            ClassBookshelves(),
          ],
        ),
      ),
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
            addVerticalSpace(8),
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
                          border: Border.all(color: Colors.grey[350]!, width: 2)
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
    return Column(
      children: [
        addVerticalSpace(4),
        // Classroom name.
        Text(classroom.classroomName, style: textTheme.headlineMedium, textAlign: TextAlign.center),
        // Number of students text.
        Text(
          "${classroom.students.length} Student${classroom.students.length == 1 ? "" : "s"}",
          style: textTheme.bodyLarge),
        addVerticalSpace(8),
      ],
    );
  }

  /// The drop down menu for displaying the option to delete the classroom.
  Widget _dropDownMenu(TextTheme textTheme) {
    return MenuAnchor(
      controller: _menuController,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: Icon(Icons.more_horiz, size: 30),
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
            _showDeleteConfirmationDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: colorRed, size: 20),
              addHorizontalSpace(8),
              Text(
                'Delete Classroom',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            _menuController.close();
            _showEditClassNameDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              addHorizontalSpace(8),
              Text('Edit Name', style: textTheme.labelLarge),
            ],
          ),
        ),
      ],
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
      ),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await appState.deleteClassroom();
                setState(() {});
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditClassNameDialog(TextTheme textTheme) {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Rename Your Classroom')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter a new classroom name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: colorGreyDark!)),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  Provider.of<AppState>(context, listen: false).renameClassroom(controller.text.trim());
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorGreen,
                foregroundColor: colorWhite
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
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
    AppState appState = Provider.of<AppState>(context);

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
                appState.changeClassroomIcon(index);
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

// Custom SliverPersistentHeaderDelegate to manage the behavior and layout of the pinned 
// classroom title and TabBar. It is responsible for building the widgets, defining their 
// height, and ensuring that they remain pinned at the top of the screen.
class _SliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverDelegate({required this.child});

  @override
  double get minExtent => child is TabBar ? (child as TabBar).preferredSize.height : 75.0;
  @override
  double get maxExtent => child is TabBar ? (child as TabBar).preferredSize.height : 75.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: 1,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return true;
  }
}
