import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal_details.dart';
import 'package:bookworms_app/models/goals/student_goal_details.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassGoalDetails extends StatefulWidget {
  final ClassroomGoal goal;
  
  const ClassGoalDetails({super.key, required this.goal});

  @override
  State<ClassGoalDetails> createState() => _ClassGoalDetailsState();
}

class _ClassGoalDetailsState extends State<ClassGoalDetails> {
  late ClassroomGoal goal;
  late MenuController menuController;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final ClassroomGoalDetails goalDetails = goal.classGoalDetails!;

    final startDate = DateTime.parse(goal.startDate);
    final endParsed = DateTime.parse(goal.endDate);
    final endDate = DateTime(endParsed.year, endParsed.month, endParsed.day);
    final dateNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int daysRemaining = endDate.difference(dateNow).inDays;

    return Scaffold(
      appBar: AppBarCustom(goal.title),
      body: Container(
        color: context.colors.surfaceBackground,
        child: ListView.builder(
          itemCount: goalDetails.studentGoalDetails!.length + 1,
          itemBuilder: (context, index) {
            // Student Completion Information.
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      border: Border(
                        bottom: BorderSide(color: context.colors.surfaceBorder),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Start Date", style: textTheme.bodyMedium),
                                        Text(
                                          "${startDate.month}/${startDate.day}/${startDate.year}", 
                                          style: textTheme.labelLarge
                                        ),
                                      ],
                                    ),
                                    addHorizontalSpace(16),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: context.colors.onSurfaceDim,
                                        thickness: 1,
                                        width: 20,
                                      ),
                                    ),
                                    addHorizontalSpace(16),
                                    Column(
                                      children: [
                                        Text("Due Date", style: textTheme.bodyMedium),
                                        Text(
                                          "${endDate.month}/${endDate.day}/${endDate.year}", 
                                          style: textTheme.labelLarge
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  child: _deleteGoalDropdown(textTheme)
                                )
                              ]
                            ),
                            addVerticalSpace(12),
                            Text(
                              "${goalDetails.studentsCompleted}/${goalDetails.studentsTotal} students completed this goal",
                              style: textTheme.titleSmall,
                            ),
                            if (daysRemaining > 0)
                            Text(
                              "$daysRemaining day${daysRemaining == 1 ? "" : "s"} until due date"
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  addVerticalSpace(8),
                ],
              );
            }
        
            // Student list.
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _studentItem(textTheme, goal, goalDetails.studentGoalDetails![index - 1]),
                  if (goalDetails.studentGoalDetails!.length != index) Divider(color: context.colors.onSurfaceDim)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _studentItem(TextTheme textTheme, ClassroomGoal goal, StudentGoalDetails studentGoalDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 35,
            child: SizedBox.expand(
              child: FittedBox(
                child: UserIcons.getIcon(studentGoalDetails.icon),
              ),
            ),
          ),
          addHorizontalSpace(16),
          Text(studentGoalDetails.name, style: textTheme.titleMedium),
          Spacer(),
          if (goal.goalMetric == "BooksRead")
            Text(
              "${studentGoalDetails.progress}/${goal.target} read", 
              style: TextStyle(
                color: goal.target <= studentGoalDetails.progress ? context.colors.primary : context.colors.delete,
                fontWeight: FontWeight.bold
              )
            ),
          if (goal.goalMetric == "Completion")
            Text(
              "${studentGoalDetails.progress}%", 
              style: TextStyle(
                color: studentGoalDetails.progress == 100 ? context.colors.primary : context.colors.delete,
                fontWeight: FontWeight.bold
              )
            )
        ],
      ),
    );
  }

  /// The drop down menu for displaying the option to delete the classroom.
  Widget _deleteGoalDropdown(TextTheme textTheme) {
    return MenuAnchor(
      controller: menuController,
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
            menuController.close();
            _showDeleteConfirmationDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: context.colors.delete, size: 20),
              addHorizontalSpace(8),
              Text(
                'Delete Goal',
                style: textTheme.bodyMedium?.copyWith(
                  color: context.colors.delete,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
  Future<void> _showDeleteConfirmationDialog(TextTheme textTheme) async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    bool shouldDelete = await showConfirmDialog(
        context,
        'Delete Goal',
        'Are you sure you want to permanently delete this goal?',
        confirmColor: context.colors.delete,
        confirmText: "Delete");

    if (!shouldDelete) {
      return;
    }

    Result result;
    if (appState.isParent) {
      result = await appState.deleteChildGoal(appState.children[appState.selectedChildID], goal.goalId!);
    } else {
      result = await appState.deleteClassroomGoal(goal.goalId);
    }

    resultAlert(context, result);
  }
}