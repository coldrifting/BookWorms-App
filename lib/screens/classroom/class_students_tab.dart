import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/student.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/student_view_screen.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late TextEditingController textEditingController;
  late List<Student> students;
  late List<Student> filteredStudents;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  /// Filters the student list based on the search input.
  void _filterStudents() {
    setState(() {
      filteredStudents = students
        .where((student) =>
          student.name.toLowerCase().contains(textEditingController.text.toLowerCase()))
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);

    students = List.of(appState.classroom!.students)
      ..sort((s1, s2) => s1.name.compareTo(s2.name));
    _filterStudents();

    return Column(
      children: [
        addVerticalSpace(8),
        // "Invite Students" button.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              // Search bar.
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SearchBar(
                    controller: textEditingController,
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(context.colors.surface),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: context.colors.surfaceBorder, width: 2),
                    )),
                    leading: Icon(Icons.search, color: context.colors.surfaceBorder),
                  ),
                ),
              ),
              addHorizontalSpace(8),
              TextButton(
                onPressed: () => _showClassroomCode(textTheme),
                style: smallButtonStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Invite"),
                    addHorizontalSpace(8),
                    Icon(Icons.person_add_alt_1_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
        // List of students in the classroom, if any.
        Expanded(
          child: students.isNotEmpty
          ? _studentsGrid(textTheme)
          : Center(
              child: Text(
                "No students in the classroom.\nUse the invite button above!",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.surfaceBorder)
              ),
            ),
        ),
      ],
    );
  }

  // Grid of students in the classroom.
  Widget _studentsGrid(TextTheme textTheme) {
    if (filteredStudents.isEmpty) {
      return Center(
        child: Text("No students to show.")
      );
    }

    return GridView.builder(
      primary: false,
      padding: const EdgeInsets.all(18),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.colors.surfaceBorder,
              blurRadius: 2,
              spreadRadius: 1,
            )
          ],
        ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      pushScreen(context, StudentViewScreen(student: filteredStudents[index]));
                    }
                  },
                  // Student icon.
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: UserIcons.getIcon(filteredStudents[index].profilePictureIndex)),
                ),
                addVerticalSpace(4),
                // Student name.
                Text(style: textTheme.titleSmall, filteredStudents[index].name),
              ],
            ),
          ),
        );
      },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Column(
            children: [
              Icon(Icons.school, color: context.colors.primary, size: 36),
              Text(
                'Classroom Code',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: context.colors.primary),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.primary, width: 2),
              ),
              child: SelectableText(
                classroomCode,
                style: textTheme.headlineMediumGreenDark.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            addVerticalSpace(12),
            Text(
              "Let’s get learning! Pass this code along so parents can enroll their students!",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: classroomCode.replaceFirst(' ', '')));
              Navigator.pop(context);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('COPY', style: textTheme.titleSmall?.copyWith(color: Colors.white)),
                    addHorizontalSpace(4),
                    const Icon(Icons.copy, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          addVerticalSpace(12),
          TextButton(
            style: smallButtonStyle,
            onPressed: () {
              String subject = "${appState.classroom!.classroomName} Classroom Access Code";
              String body = "Use the following code to join ${appState.account.lastName}'s Classroom in the BookWorms App: \r\n ${appState.classroom!.classCode}";

              Navigator.pop(context);

              // Open User Email App with code pre filled in
             final Uri emailLaunchUri = Uri(
               scheme: 'mailto',
               path: '',
               query: "subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}"
              );
             launchUrl(emailLaunchUri);

            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('EMAIL', style: textTheme.titleSmall?.copyWith(color: Colors.white)),
                    addHorizontalSpace(4),
                    const Icon(Icons.mail, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}