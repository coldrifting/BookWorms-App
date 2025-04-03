import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Creates a SizedBox widget with specified height.
Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

// Creates a SizedBox widget with specified width.
Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Future<void> pushScreen(context, screen, {replace = false, root = false}) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) => screen);

  if (replace) {
    return Navigator.of(context, rootNavigator: root).pushReplacement(route);
  }
  else {
    return Navigator.of(context, rootNavigator: root).push(route);
  }
}

// Returns the first 'count' of authors stylistically.
String printFirstAuthors(var authorList, int count) {
  var authors = authorList.take(count);
  return authors.length < count
    ? authors.join(", ")
    : "${authors.join(", ")}, and more";
}

SystemUiOverlayStyle defaultOverlay([Color? color, bool light = true]) {
  return SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: color ?? colorGreen,

    // Status bar icon brightness
    // For Android
    statusBarIconBrightness: light == true ? Brightness.light : Brightness.dark,

    // For iOS
    statusBarBrightness:  light == true ? Brightness.light : Brightness.dark,
  );
}

// Alert modal for adding a new classroom goal.
Future<void> addGoalAlert(TextTheme textTheme, BuildContext context, [void Function()? callback]) {
  AppState appState = Provider.of<AppState>(context, listen: false);
  var isParent = appState.isParent;
  var isNumBooksMetric = false;
  
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController titleController = TextEditingController();
      TextEditingController startDateController = TextEditingController(text: _convertDateToStringUI(DateTime.now()));
      TextEditingController dueDateController = TextEditingController(text: _convertDateToStringUI(DateTime.now().add(Duration(days: 1))));
      TextEditingController booksReadController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      
      String selectedMetric = "Completion";
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
                  Text("Add Classroom Goal", style: textTheme.headlineSmall?.copyWith(color: colorGreen, fontWeight: FontWeight.bold)),
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
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel", style: TextStyle(color: colorRed)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!isParent) {
                      if (formKey.currentState?.validate() ?? false) {
                        Goal newGoal = Goal(
                          goalType: "Classroom",
                          goalMetric: selectedMetric,
                          title: titleController.text,
                          startDate: _convertDateToString(DateTime.now()),
                          endDate: _convertDateToString(pickedDate!),
                          target: isNumBooksMetric ? int.parse(booksReadController.text) : 0,
                        );

                        Result result = await appState.addClassroomGoal(newGoal);
                        setState(() {
                          if (callback != null) {
                            callback();
                          }
                        });
                        resultAlert(context, result);
                      }
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

String _convertDateToString(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String _convertDateToStringUI(DateTime date) {
  return "${date.month}/${date.day}/${date.year}";
}

dynamic resultAlert(BuildContext context, Result result) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: result.isSuccess ? colorGreenDark : colorRed,
        content: Row(
          children: [
            Text(
              result.message, 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Icon(
              result.isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline, 
              color: Colors.white
            )
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }
}