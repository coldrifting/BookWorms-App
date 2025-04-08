import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> goalAlert(BuildContext context, [void Function()? callback, dynamic goal]) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => GoalModal(callback: callback, goal: goal),
  );
}

class GoalModal extends StatefulWidget {
  final void Function()? callback;
  final dynamic goal;

  const GoalModal({super.key, this.callback, this.goal});

  @override
  State<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends State<GoalModal> {
  late TextEditingController titleController;
  late TextEditingController startDateController;
  late TextEditingController dueDateController;
  late TextEditingController booksReadController;
  late TextEditingController inputProgressController;

  final formKey = GlobalKey<FormState>();
  bool isNumBooksMetric = false;
  bool isChecked = false;
  String selectedMetric = "Completion";
  DateTime? pickedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.goal?.title);
    startDateController = TextEditingController(
      text: widget.goal == null 
        ? convertDateToString(DateTime.now())
        : convertDateToString(DateTime.parse(widget.goal.startDate))
      );
    dueDateController = TextEditingController(
      text: widget.goal == null
      ? convertDateToString(DateTime.now().add(Duration(days: 1)))
      : convertDateToString(DateTime.parse(widget.goal.endDate))
    );
    booksReadController = TextEditingController();
    if (widget.goal != null) {
      inputProgressController = TextEditingController(text: widget.goal.progress.toString());
    }
    pickedDate = DateTime.now().add(Duration(days: 1));
  }

  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    dueDateController.dispose();
    booksReadController.dispose();
    super.dispose();
  }

  Future<void> selectDate(TextEditingController controller, DateTime date) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (newDate != null) {
      setState(() {
        pickedDate = newDate;
        controller.text = "${newDate.month}/${newDate.day}/${newDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final TextTheme textTheme = Theme.of(context).textTheme;
    var isParent = appState.isParent;
    dynamic goal = widget.goal;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),  // Prevents unintentional focus loss.
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(Icons.school, color: colorGreen),
            Text(
              "${goal == null ? "Add" : "Edit"} Classroom Goal",
              style: textTheme.headlineSmall?.copyWith(color: colorGreen, fontWeight: FontWeight.bold),
            ),
            Divider(color: colorGrey),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (goal == null || (goal.goalType != "Classroom" && goal.goalType != "ClassroomAggregate")) ...[
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Goal Title",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.star, color: colorYellow),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please input a goal title' : null,
                  ),
                  addVerticalSpace(16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startDateController,
                          readOnly: true,
                          onTap: () => selectDate(startDateController, convertStringToDate(startDateController.text)),
                          decoration: InputDecoration(
                            labelText: "Start Date",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                          ),
                        ),
                      ),
                      addHorizontalSpace(4),
                      Expanded(
                        child: TextFormField(
                          controller: dueDateController,
                          readOnly: true,
                          onTap: () => selectDate(dueDateController, convertStringToDate(dueDateController.text)),
                          decoration: InputDecoration(
                            labelText: "Due Date",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ],
                addVerticalSpace(16),
                if (goal == null) ...[
                  Text("Metric Type", style: textTheme.titleMedium!.copyWith(color: colorGreyDark)),
                  ToggleButtons(
                    isSelected: [!isNumBooksMetric, isNumBooksMetric],
                    onPressed: (index) {
                      setState(() {
                        isNumBooksMetric = index == 1;
                        selectedMetric = isNumBooksMetric ? "BooksRead" : "Completion";
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    constraints: BoxConstraints(minWidth: 130, minHeight: 40),
                    children: [Text("Completion"), Text("Number-Read")],
                  ),
                  addVerticalSpace(8),
                if (!isNumBooksMetric)
                  Text(
                    "ⓘ Measure progress by the portion of a book or task completed.", 
                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    textAlign: TextAlign.center, 
                  ),
                if (isNumBooksMetric) ...[
                  Text(
                      "ⓘ Track the total number of books, chapters, or minutes read.", 
                      style: TextStyle(color: Colors.grey[800], fontSize: 13), 
                      textAlign: TextAlign.center, 
                    ),
                  addVerticalSpace(8),
                  TextFormField(
                    controller: booksReadController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: "Number-Read Target",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.insert_chart_outlined_rounded, color: Colors.purple),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please input a reading target' : null,
                  ),
                ],
                addVerticalSpace(16),
                if (!isParent && isNumBooksMetric)
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: colorGreen,
                        onChanged: (value) => setState(() => isChecked = value!),
                      ),
                      Text("Class-Wide Goal", style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                    ],
                  ),
                ],
                if (goal != null) ...[
                  Text("Input Progress", style: textTheme.titleMedium!.copyWith(color: colorGreyDark)),
                  CounterWidget(goal: goal, controller: inputProgressController)
                ]
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: colorRed)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                Result result;
                if (goal == null) {
                  Goal newGoal = Goal(
                    goalType: isParent 
                      ? "Child"
                      : isChecked ? "ClassroomAggregate" : "Classroom",
                    goalMetric: selectedMetric,
                    title: titleController.text,
                    startDate: convertStringToDateString(startDateController.text),
                    endDate: convertStringToDateString(dueDateController.text),
                    target: isNumBooksMetric ? int.parse(booksReadController.text) : 0,
                    progress: 0
                  );
                  if (!isParent) {
                    result = await appState.addClassroomGoal(newGoal);
                  } else {
                    Child selectedChild = appState.children[appState.selectedChildID];
                    result = await appState.addChildGoal(selectedChild, newGoal);
                  }
                  setState(() {
                    if (widget.callback != null) {
                      widget.callback!();
                    }
                  });
                } else {
                  Child selectedChild = appState.children[appState.selectedChildID];
                  result = await appState.editChildGoal(
                    selectedChild,
                    goal.goalId, 
                    titleController.text, 
                    convertStringToDateString(startDateController.text),
                    convertStringToDateString(dueDateController.text),
                    int.parse(inputProgressController.text)
                  );
                }
                resultAlert(context, result);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(goal != null ? "Submit": "Add Goal", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
