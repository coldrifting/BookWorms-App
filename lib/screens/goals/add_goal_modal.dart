// Alert modal for adding a new classroom goal.
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> addGoalAlert(TextTheme textTheme, BuildContext context, [void Function()? callback]) {
  AppState appState = Provider.of<AppState>(context, listen: false);
  var isParent = appState.isParent;
  var isNumBooksMetric = false;
  
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController titleController = TextEditingController();
      TextEditingController startDateController = TextEditingController(text: convertDateToStringUI(DateTime.now()));
      TextEditingController dueDateController = TextEditingController(text: convertDateToStringUI(DateTime.now().add(Duration(days: 1))));
      TextEditingController booksReadController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      
      String selectedMetric = "Completion";
      bool isChecked = false;
      DateTime? pickedDate = DateTime.now().add(Duration(days: 1));

      return StatefulBuilder(
        builder: (context, setState) {
          // Function to select a date.
          Future<void> selectDate(TextEditingController controller) async {
            pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2026),
            );
            setState(() {
              if (pickedDate != null) {
                controller.text = "${pickedDate!.month}/${pickedDate!.day}/${pickedDate!.year}";
              }
            });
          }

          return Form(
            key: formKey,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Column(
                children: [
                  Icon(Icons.school, color: colorGreen),
                  addHorizontalSpace(8),
                  Text(
                    isParent ? "Add Child Goal" : "Add Classroom Goal", 
                    style: textTheme.headlineSmall?.copyWith(color: colorGreen, fontWeight: FontWeight.bold)
                  ),
                  Divider(color: colorGrey)
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Goal Title.
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Goal Title",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.star, color: colorYellow),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input a goal title';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(16),
                  Row(
                    children: [
                      // Start Date.
                      Expanded(
                        child: TextFormField(
                          controller: startDateController,
                          readOnly: true,
                          onTap: () => selectDate(startDateController),
                          decoration: InputDecoration(
                            labelText: "Start Date",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                          ),
                          validator: (value) {
                            if (value == null || value == "No selected date") {
                              return 'Please input a due date';
                            }
                            return null;
                          },
                        ),
                      ),
                      addHorizontalSpace(4),
                      // End Date.
                      Expanded(
                        child: TextFormField(
                          controller: dueDateController,
                          readOnly: true,
                          onTap: () => selectDate(dueDateController),
                          decoration: InputDecoration(
                            labelText: "Due Date",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please input a due date';
                            }
                            DateTime startDate = DateFormat("MM/dd/yyyy").parse(startDateController.text);
                            DateTime dueDate = DateFormat("MM/dd/yyyy").parse(value);

                            if (dueDate.isBefore(startDate)) {
                              return 'Invalid due date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(16),
                  // Metric Type.
                  Align(
                    alignment: Alignment.center,
                    child: Text("Metric Type", style: textTheme.titleMedium!.copyWith(color: colorGreyDark)),
                  ),
                  addVerticalSpace(4),
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
                    children: [
                      Text("Completion", textAlign: TextAlign.center),
                      Text("Number-Read", textAlign: TextAlign.center),
                    ],
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input a reading target';
                        }
                        return null;
                      },
                    ),
                  ],
                  if (!isParent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 32,
                          child: Checkbox(
                            value: isChecked, 
                            activeColor: colorGreen,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            }
                          ),
                        ),
                        Text("Class-Wide Goal", style: TextStyle(color: Colors.grey[800], fontSize: 14))
                      ],
                    )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel", style: TextStyle(color: colorRed)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      Goal newGoal = Goal(
                        goalType: isParent 
                          ? "Child"
                          : isChecked ? "ClassroomAggregate" : "Classroom",
                        goalMetric: selectedMetric,
                        title: titleController.text,
                        startDate: convertDateToString(DateTime.now()),
                        endDate: convertDateToString(pickedDate!),
                        target: isNumBooksMetric ? int.parse(booksReadController.text) : 0,
                      );
                      Result result;
                      if (!isParent) {
                        result = await appState.addClassroomGoal(newGoal);
                      } else {
                        Child selectedChild = appState.children[appState.selectedChildID];
                        result = await appState.addChildGoal(selectedChild, newGoal);
                      }
                      setState(() {
                        if (callback != null) {
                          callback();
                        }
                      });
                      resultAlert(context, result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Save Goal", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      );
    }
  );
}