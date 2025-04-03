import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/goals/goal.dart';
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

Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    {String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color confirmColor = colorGreen,
    Color cancelColor = colorGreyDark}) async {
  var result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title, textAlign: TextAlign.center)),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
              dialogButton(
                  cancelText,
                  () => Navigator.of(context, rootNavigator: true).pop(false),
                  foregroundColor: cancelColor,
                  isElevated: false),
              dialogButton(
                  confirmText,
                  () => Navigator.of(context, rootNavigator: true).pop(true),
                  foregroundColor: colorWhite,
                  backgroundColor: confirmColor),
          ],
        );
      });

  return result == true;
}

// Null for cancel
Future<String?> showTextEntryDialog(
    BuildContext context, String title, String hint,
    {String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color confirmColor = colorGreen}) async {
  var result = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        String input = "";
        TextEditingController textEditingController = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              autofocus: true,
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: hint,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => input = value);
              },
            ),
            actions: [
              dialogButton(
                  cancelText,
                  () => Navigator.of(context, rootNavigator: true).pop(null),
                  foregroundColor: colorGreyDark,
                  isElevated: false),
              dialogButton(
                  confirmText,
                  input.isEmpty ? null : () => Navigator.of(context, rootNavigator: true).pop(input),
                  foregroundColor: colorWhite,
                  backgroundColor: confirmColor),
            ],
          );
        });
      });

  return result;
}

void confirmExitWithoutSaving(
    BuildContext context,
    NavigatorState navState,
    bool hasChanges) async {
  if (hasChanges) {
    bool result = await showConfirmDialog(
        context,
        "Unsaved Changes",
        "Are you sure you want to continue?",
        confirmText: "Discard Changes",
        confirmColor: colorRed);
    if (result) {
      navState.pop();
    }
  } else {
    navState.pop();
  }
}

Widget dialogButton(String label, Function()? onPressed,
    {Color foregroundColor = colorWhite,
    Color backgroundColor = colorGreen,
    bool isElevated = true}) {
  var text = Text(label);

  if (isElevated) {
    return ElevatedButton(
        onPressed: onPressed,
        style: getCommonButtonStyle(
            primaryColor: onPressed != null ? backgroundColor : colorGreyDark,
            secondaryColor: onPressed != null ? foregroundColor : colorWhite),
        child: text);
  }
  return TextButton(
      onPressed: onPressed,
      style: getCommonButtonStyle(primaryColor: foregroundColor, isElevated: false),
      child: text);
}

ButtonStyle getCommonButtonStyle({Color primaryColor = colorGreen, Color? secondaryColor = colorWhite, bool isElevated = true}) {
  return ElevatedButton.styleFrom(
          backgroundColor: isElevated ? primaryColor : Colors.transparent,
          foregroundColor: isElevated ? secondaryColor : primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
}

FloatingActionButton floatingActionButtonWithText(String label, IconData icon, Function() action) {
  return FloatingActionButton.extended(
        foregroundColor: colorWhite,
        backgroundColor: colorGreen,
        label: Text(label),
        icon: Icon(icon),
        onPressed: action);
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
  dynamic addGoalAlert(TextTheme textTheme, BuildContext context, [void Function()? callback]) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    var isParent = appState.isParent;
    
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
                            if (!isParent) {
                              if (formKey.currentState?.validate() ?? false) {
                                DateTime today = DateTime.now();
                                Goal newGoal = Goal(
                                  goalType: "Classroom",
                                  goalMetric: selectedMetric,
                                  title: titleController.text,
                                  startDate: "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}", // TODO
                                  endDate: "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}",
                                  target: 0 //TODO
                                );

                                Result result = await appState.addClassroomGoal(newGoal);
                                setState(() {
                                  if (callback != null) {
                                    callback();
                                  }
                                });
                                if (context.mounted) {
                                  resultAlert(context, result);
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