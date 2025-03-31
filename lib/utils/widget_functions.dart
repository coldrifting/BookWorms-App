import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:provider/provider.dart';

// Creates a SizedBox widget with specified height.
Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

// Creates a SizedBox widget with specified width.
Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

void pushScreen(context, screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen
    )
  );
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
  dynamic addGoalAlert(TextTheme textTheme, BuildContext context, bool isChildGoal, [void Function()? callback]) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController dateController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        
        String selectedMetric = "Completion";
        DateTime? pickedDate;

        return StatefulBuilder(
          builder: (context, setState) {

            // On click, pulls up the date picker.
            Future<void> selectDate() async {
              pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2025),
                lastDate: DateTime(2026)
              );

              setState(() {
                dateController.text = pickedDate != null 
                  ? "${pickedDate!.month}/${pickedDate!.day}/${pickedDate!.year}"
                  : "No selected date";
              });
            }

            return Form(
              key: formKey,
              child: AlertDialog(
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text("Add Class Goal"),
                        addHorizontalSpace(32),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.cancel, size: 32, color: colorGreyDark),
                        ),
                        addHorizontalSpace(4),
                        InkWell(
                          onTap: () async {
                            if (!isChildGoal) {
                              if (formKey.currentState?.validate() ?? false) {
                                DateTime today = DateTime.now();
                                Goal newGoal = Goal(
                                  goalType: "Classroom",
                                  goalMetric: selectedMetric,
                                  title: titleController.text,
                                  startDate: "${today.year}-${today!.month.toString().padLeft(2, '0')}-${today!.day.toString().padLeft(2, '0')}", // TODO
                                  endDate: "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}",
                                  target: 0 //TODO
                                );

                                await appState.addClassroomGoal(newGoal);
                                setState(() {
                                  if (callback != null) {
                                    callback();
                                  }
                                });

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: colorGreenDark,
                                      content: Row(
                                        children: [
                                          Text(
                                            'Successfully created class goal!', 
                                            style: textTheme.titleSmallWhite,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Spacer(),
                                          Icon(Icons.check_circle_outline_rounded, color: colorWhite)
                                        ],
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                          child: Icon(Icons.check_circle_rounded, size: 32, color: colorGreen),
                        ),
                      ],
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
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input a goal title';
                        }
                        return null;
                      },
                    ),
                    addVerticalSpace(16),
                    // End Date.
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: selectDate,
                      decoration: InputDecoration(
                        labelText: "Select Due Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value == "No selected date") {
                          return 'Please input a due date';
                        }
                        return null;
                      },
                    ),
                    addVerticalSpace(16),
                    // Metric Type.
                    DropdownButtonFormField<String>(
                      onChanged: (value) {
                        setState(() {
                          selectedMetric = value!;
                        });
                      },
                      items: ["Completion", "Number of Books"]
                        .map((metric) => DropdownMenuItem(
                          value: metric,
                          child: Text(metric, style: textTheme.bodyLarge),
                        ))
                        .toList(),
                      decoration: InputDecoration(
                        labelText: "Metric Type",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a metric';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
