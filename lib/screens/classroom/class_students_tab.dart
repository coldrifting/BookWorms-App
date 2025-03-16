import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/student.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/student_view_screen.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late List<Student> students;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    students = appState.classroom!.students;

    return Column(
      children: [
        addVerticalSpace(8),
        // "Invite Students" button.
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Invite Students"),
                addHorizontalSpace(8),
                Icon(Icons.person_add_alt_1_rounded, color: colorWhite),
              ],
            ),
          ),
        ),
        // List of students in the classroom, if any.
        students.isNotEmpty
        ? _studentsGrid(textTheme)
        : const Center(
            child: Text(
              textAlign: TextAlign.center,
              "No students in the classroom.\n Use the invite button above!"
            ),
          ),
      ],
    );
  }

  // Grid of students in the classroom.
  Widget _studentsGrid(TextTheme textTheme) {
    return Expanded(
      child: GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(18),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(20),
                blurRadius: 4,
                spreadRadius: 2,
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
            ),
          );
        },
      )
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
              Icon(Icons.school, color: colorGreen!, size: 36),
              Text(
                'Classroom Code',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorGreen),
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
                color: colorGreen!.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorGreen!, width: 2),
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
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colorGreen, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        ],
      ),
    );
  }
}