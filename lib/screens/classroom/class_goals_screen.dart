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
          itemCount: 10, // goals.length
          itemBuilder: (context, index) {
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
                          Text(
                            "Daily Reading",
                            style: textTheme.titleLarge,
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 24,
                          ),
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
          },
        ),
      ),
    );
  }
}
