import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/announcements/announcements_all_screen.dart';
import 'package:bookworms_app/screens/classroom/class_bookshelves_tab.dart';
import 'package:bookworms_app/screens/classroom/class_students_tab.dart';
import 'package:bookworms_app/screens/classroom/create_classroom_screen.dart';
import 'package:bookworms_app/screens/goals/goals_screen.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/screens/classroom/create_classroom_screen.dart';
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

  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('classroom');

  @override
  void initState() {
    super.initState();
    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    String headerTitle = appState.classroom != null
            ? "My Classroom"
            : "Create Classroom";

    return Scaffold(
      appBar: AppBarCustom(headerTitle, isLeafPage: false),
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

    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // Classroom header.
              SliverToBoxAdapter(child: _classroomHeader(textTheme, classroom)),

          // Pinned classroom header.
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverDelegate(
              child: _pinnedClassroomHeader(textTheme, classroom),
              elevation: 1
            ),
          ),

          // Pinned TabBar.
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverDelegate(
              elevation: 1,
              child: TabBar(
                labelStyle: textTheme.labelLarge,
                labelColor: context.colors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: context.colors.primary,
                tabs: const [
                  Tab(icon: Icon(Icons.groups), text: "Students"),
                  Tab(icon: Icon(Icons.insert_chart_outlined_sharp), text: "Goals"),
                  Tab(icon: Icon(Icons.collections_bookmark_rounded), text: "Shelves"),
                  Tab(icon: Icon(Icons.announcement_outlined), text: "Announce"),
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
            AnnouncementsAllScreen(),
          ],
        ),

        // Invisible element for showing existing classroom
        Positioned(
          top: 250,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BWShowcase(
                showcaseKey: navKeys[0],
                title: "Welcome to your classroom!!",
                description:
                  "Classrooms have many exciting features. "
                  "You can create class lists, set class goals and reading assignments, "
                  "and even send notifications to parents of students in your class.",
                disableMovingAnimation: true,
                showArrow: false,
                child: SizedBox(
                    width: 0,
                    height: 0
                )
              )
            ]
          ),
        ),
      ]
    );
  }

  /// Classroom information (icon, name, number of students).
  Widget _classroomHeader(TextTheme textTheme, Classroom classroom) {
    return Container(
      color: context.colors.surface,
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
                          color: context.colors.surface,
                          border: Border.all(color: context.colors.surfaceBorder, width: 2)
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
                          fillColor: context.colors.surface,
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
    AppState appState = Provider.of<AppState>(context);
    return MenuAnchor(
      alignmentOffset: Offset(-125,0),
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
            appState.setClassroomDetails();
          },
          child: Row(
            children: [
              Icon(Icons.refresh, color: context.colors.primary, size: 20),
              addHorizontalSpace(8),
              Text('Refresh', style: textTheme.labelLarge?.copyWith(color: context.colors.primary)),
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
              Text('Rename Classroom', style: textTheme.labelLarge),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            _menuController.close();
            _showDeleteConfirmationDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: context.colors.delete, size: 20),
              addHorizontalSpace(8),
              Text(
                'Delete Classroom',
                style: textTheme.bodyMedium?.copyWith(
                  color: context.colors.delete,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(context.colors.surface),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
      ),
    );
  }


  /// Confirmation dialog to confirm the deletion of the classroom.
  Future<dynamic> _showDeleteConfirmationDialog(TextTheme textTheme) async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    bool? shouldDelete = await showConfirmDialog(
        context,
        'Delete Classroom',
        'Are you sure you want to permanently delete this classroom?',
        confirmColor: context.colors.delete,
        confirmText: "Delete");

    if (shouldDelete) {
      Result result = await appState.deleteClassroom();
      resultAlert(context, result, false);
    }
  }

  Future<void> _showEditClassNameDialog(TextTheme textTheme) async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    String? newClassName = await showTextEntryDialog(
        context,
        'Rename Your Classroom',
        "Enter a new classroom name",
        confirmText: "Save");

    if (newClassName == null) {
      return;
    }

    Result result = await appState.renameClassroom(newClassName);
    resultAlert(context, result, false);
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
            onTap: () async {
              // Change selected color and exit popup.
              Result result = await appState.changeClassroomIcon(index);
              if (result.isSuccess) {
                setState(() {
                  selectedIconIndex = index;
                });
              }
              resultAlert(context, result);
            },
            child: Material(
              shape: CircleBorder(
                side: BorderSide(
                  color: selectedIconIndex == index
                      ? Colors.grey[400]!
                      : Colors.grey[300]!
                ),
              ),
              shadowColor: selectedIconIndex == index
                  ? context.colors.surfaceBorder
                  : Colors.transparent,
              elevation: selectedIconIndex == index ? 4 : 2,
              child: CircleAvatar(
                backgroundColor: context.colors.surface,
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
  final double elevation;

  _SliverDelegate({required this.child, this.elevation = 0});

  @override
  double get minExtent => child is TabBar ? (child as TabBar).preferredSize.height : 75.0;
  @override
  double get maxExtent => child is TabBar ? (child as TabBar).preferredSize.height : 75.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: elevation,
      color: context.colors.surface,
      shadowColor: context.colors.surfaceBorder,
      child: child
    );
  }

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return true;
  }
}
