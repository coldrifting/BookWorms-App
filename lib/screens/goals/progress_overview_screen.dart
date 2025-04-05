import 'package:bookworms_app/screens/goals/line_graph.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class ProgressOverviewScreen extends StatefulWidget {
  const ProgressOverviewScreen({super.key});

  @override
  State<ProgressOverviewScreen> createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(16),
        LineGraph()
      ],
    );
  }
}