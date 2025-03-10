import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ClassGoalsScreen extends StatefulWidget {
  const ClassGoalsScreen({super.key, });

  @override
  State<ClassGoalsScreen> createState() => _ClassGoalsScreenState();
}

var x = SystemUiOverlayStyle(
  // Status bar color
  statusBarColor: Colors.red,

  // Status bar brightness (optional)
  statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  statusBarBrightness: Brightness.light, // For iOS (dark icons)
);

class _ClassGoalsScreenState extends State<ClassGoalsScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    List<ClassroomGoal> goals = []; // Temporary

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text("Class Goals",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorWhite,
            overflow: TextOverflow.ellipsis)),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: colorGreyLight,
        child: ListView.builder(
          itemCount: 5 + 1, // goals.length + 1
          itemBuilder: (context, index) {
            if (index != 0) {
              return InkWell(
                child: classGoalItem(textTheme),
                onTap: () {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassGoalDetails()),
                    );
                  }
                }
              );
            } else {
              return _addClassGoalWidget(textTheme);
            }
          },
        ),
      ),
    );
  }

  Widget classGoalItem(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Daily Reading", style: textTheme.titleLarge),
                  Icon(Icons.arrow_forward_rounded, size: 24, color: colorGreyDark),
                ],
              ),
              addVerticalSpace(8),
              Text("Completed by 23/31 students", style: textTheme.bodyMedium),
              addVerticalSpace(8),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: 0.8,
                progressColor: colorGreen,
                barRadius: const Radius.circular(4),
              ),
              addVerticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Average Time", style: textTheme.bodyMedium),
                      Text("30 min.", style: textTheme.labelLarge),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                      width: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("End Date", style: textTheme.bodyMedium),
                      Text("Today, 11:59pm", style: textTheme.labelLarge),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addClassGoalWidget(TextTheme textTheme) {
    List<ClassroomGoal> goals = [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  goals.isEmpty ? "Add your first class goal" : "Add a new goal", 
                  style: textTheme.titleMedium
                ),
                Spacer(),
                Icon(Icons.add_circle_outline, size: 32, color: colorGreyDark),
              ],
            )
          )
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController dateController = TextEditingController();
              String selectedMetric = "Completion";

              return StatefulBuilder(
                builder: (context, setState) {

                  // On click, pulls up the date picker.
                  Future<void> selectDate() async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2026)
                    );

                    setState(() {
                      dateController.text = pickedDate != null 
                        ? "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}"
                        : "No selected date";
                    });
                  }

                  return AlertDialog(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text("Add Class Goal"),
                            addHorizontalSpace(32),
                            Icon(Icons.cancel, size: 32),
                            addHorizontalSpace(4),
                            Icon(Icons.check_circle_rounded, size: 32)
                          ],
                        ),
                        Divider(color: colorGrey)
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Goal Title.
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Goal Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        addVerticalSpace(16),
                        // End Date.
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: selectDate,
                          decoration: InputDecoration(
                            labelText: "Select End Date",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
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
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      ),
    );
  }
}
