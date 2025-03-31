import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal_details.dart';
import 'package:bookworms_app/models/goals/student_goal_details.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
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
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(goal.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorWhite,
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: colorGreyLight,
        child: ListView.builder(
          itemCount: goalDetails.studentGoalDetails!.length + 1,
          itemBuilder: (context, index) {
            // Student Completion Information.
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorWhite,
                      border: Border(
                        bottom: BorderSide(color: colorGrey),
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
                                        color: Colors.black,
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
              child: Container(
                color: colorWhite,
                child: Column(
                  children: [
                    _studentItem(textTheme, goalDetails.studentGoalDetails![index - 1]),
                    if (goalDetails.studentGoalDetails!.length != index) Divider(color: colorGreyLight)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _studentItem(TextTheme textTheme, StudentGoalDetails studentGoalDetails) {
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
          if (true)// TODO: if (studentGoalDetails.progress)
            Text("COMPLETE", style: TextStyle(color: colorGreen, fontWeight: FontWeight.bold))
          else 
            Text("INCOMPLETE", style: TextStyle(color: colorRed, fontWeight: FontWeight.bold))
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
              Icon(Icons.delete_forever, color: colorRed, size: 20),
              addHorizontalSpace(8),
              Text(
                'Delete Goal',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // MenuItemButton(
        //   onPressed: () {
        //     menuController.close();
        //     _showDeleteConfirmationDialog(textTheme);
        //   },
        //   child: Row(
        //     children: [
        //       Icon(Icons.edit, size: 20),
        //       addHorizontalSpace(8),
        //       Text('Edit Name', style: textTheme.labelLarge),
        //     ],
        //   ),
        // ),
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
          title: const Center(child: Text('Delete Delete')),
          content: const Text('Are you sure you want to permanently delete this goal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await appState.deleteClassroomGoal(goal.goalId);
                //setState(() {});
              },
              child: Text('Delete', style: TextStyle(color: colorRed)),
            ),
          ],
        );
      },
    );
  }
}