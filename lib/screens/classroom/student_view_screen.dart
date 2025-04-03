import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/classroom/student.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:provider/provider.dart';

class StudentViewScreen extends StatefulWidget {
  final Student student;
  const StudentViewScreen({super.key, required this.student});

  @override
  State<StudentViewScreen> createState() => _StudentViewScreenState();
}

class _StudentViewScreenState extends State<StudentViewScreen> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navState = Navigator.of(context);

    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text("",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: colorWhite,
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navState.pop(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ExtendedAppBar(
              name: student.name,
              icon: UserIcons.getIcon(student.profilePictureIndex)
            ),
            addVerticalSpace(16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorRed,
                foregroundColor: colorWhite,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) { 
                  return AlertWidget(
                    title: "Remove Student from Class", 
                    message: "Removing this student cannot be undone. Are you sure you want to continue?", 
                    confirmText: "Remove", 
                    confirmColor: colorRed,
                    cancelColor: colorGreyDark,
                    cancelText: "Cancel", 
                    action: _removeStudent
                  );
                }
              ),
              child: Text('Remove Student', style: textTheme.titleSmallWhite),
            ),
          ],
        ),
      ),
    );
  }

  // Deletes the user's account and navigates to homescreen.
  Future<void> _removeStudent() async {
    NavigatorState navState = Navigator.of(context);
    AppState appState = Provider.of<AppState>(context, listen: false);
    Result result = await appState.deleteStudentFromClassroom(student.id);
    navState.pop();
    resultAlert(context, result);
  }
}
