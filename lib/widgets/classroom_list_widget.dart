import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/join_classroom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ClassroomListWidget extends StatefulWidget {
  const ClassroomListWidget({super.key});

  @override
  State<ClassroomListWidget> createState() => _ClassroomListWidgetState();
}

class _ClassroomListWidgetState extends State<ClassroomListWidget> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    List<Classroom> classrooms = appState.children[appState.selectedChildID].classrooms;

    return Container(
      color: context.colors.surface,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Container(
          height: classrooms.isEmpty ? 180 : 220,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: context.colors.classroomDark, width: 2)),
            boxShadow: [
              BoxShadow(
                color: context.colors.surfaceBorder.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
            color: context.colors.classroom,
          ),
          child: classrooms.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.school, color: context.colors.onPrimary),
                      addHorizontalSpace(8),
                      Text("Classroom Overview", style: textTheme.titleMediumWhite),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  "Join a classroom to start learning!",
                  style: textTheme.bodyLargeWhite,
                  textAlign: TextAlign.center,
                ),
                addVerticalSpace(4),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: TextButton(
                    onPressed: () => joinClassDialog(context, textTheme, appState.selectedChildID),
                    style: buttonStyle(context, context.colors.classroomDark, context.colors.onPrimary),
                    child: const Text("Join Classroom"),
                  ),
                ),
                addVerticalSpace(16)
              ],
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  addHorizontalSpace(12),
                  Icon(Icons.school, color: context.colors.onPrimary),
                  addHorizontalSpace(8),
                  Text("Classroom Overview", style: textTheme.titleMediumWhite),
                ],
              ),
              addVerticalSpace(8),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: classrooms.length + 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.classroomLight,
                          border: Border.all(color: context.colors.classroom, width: 3),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        width: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            index != classrooms.length  
                            ? InkWell(
                                onTap: () async {
                                bool? shouldLeave = await showConfirmDialog(context,
                                  "Leave Classroom",
                                  'Are you sure you want to leave "${classrooms[index].classroomName}?"',
                                  confirmColor: context.colors.delete);
                                  if (shouldLeave == true) {
                                    Result result = await appState.leaveChildClassroom(appState.selectedChildID, classrooms[index].classCode);
                                    resultAlert(context, result, false);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: context.colors.classroom, width: 2)
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: context.colors.surfaceVariant,
                                    maxRadius: 35,
                                    child: Icon(
                                      size: 50,
                                      Icons.school,
                                      color: classroomColors[classrooms[index].classIcon]
                                    ),
                                  ),
                                ),
                              )

                            : InkWell(
                              onTap: () => joinClassDialog(context, textTheme, appState.selectedChildID),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Join\nClassroom", style: textTheme.titleSmallWhite, textAlign: TextAlign.center),
                                  addVerticalSpace(4),
                                  Icon(Icons.add, color: context.colors.onPrimary)
                                ],
                              ),
                            ),
                            addVerticalSpace(4),
                            if (index != classrooms.length)
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    classrooms[index].classroomName,
                                    style: textTheme.titleSmallWhite, 
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}