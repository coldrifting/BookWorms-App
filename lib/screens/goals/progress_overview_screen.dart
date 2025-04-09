import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/goals/line_graph.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressOverviewScreen extends StatefulWidget {
  const ProgressOverviewScreen({super.key});

  @override
  State<ProgressOverviewScreen> createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  int booksReadMonthCount = 0;
  int booksReadYearCount = 0;
  int goalsCompletedMonthCount = 0;
  int goalsCompletedYearCount = 0;

  bool _statsCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final childData = appState.children[appState.selectedChildID];

        // Show loading until bookshelves are loaded.
        if (childData.bookshelves.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_statsCalculated) {
          _calculateStats(appState, childData);
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              addVerticalSpace(16),
              const LineGraph(),
              addVerticalSpace(16),
              _readingStats(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _calculateStats(AppState appState, childData) async {
    final booksCompleted = await _getBooksCompleted(appState, childData);
    final goalsCompleted = await _getGoalsCompleted(childData);

    if (!mounted) return;

    setState(() {
      booksReadYearCount = booksCompleted[0];
      booksReadMonthCount = booksCompleted[1];
      goalsCompletedYearCount = goalsCompleted[0];
      goalsCompletedMonthCount = goalsCompleted[1];
      _statsCalculated = true;
    });
  }

  Future<List<int>> _getBooksCompleted(AppState appState, childData) async {
    final bookshelves = childData.bookshelves;
    final index = bookshelves.indexWhere((b) => b.type == BookshelfType.completed);
    final completedShelf = await appState.getChildBookshelf(appState.selectedChildID, index);

    int currYear = DateTime.now().year;
    int currMonth = DateTime.now().month;
    int yearCount = 0;
    int monthCount = 0;

    if (completedShelf.completedDates != null) {
      for (var bookCompletion in completedShelf.completedDates!) {
        String date = bookCompletion.completedDate;
        if (getYearFromDateString(date) == currYear) yearCount++;
        if (getMonthFromDateString(date) == currMonth) monthCount++;
      }
    }

    return [yearCount, monthCount];
  }

  Future<List<int>> _getGoalsCompleted(childData) async {
    final goals = childData.goals;

    int currYear = DateTime.now().year;
    int currMonth = DateTime.now().month;
    int yearCount = 0;
    int monthCount = 0;

    for (var goal in goals) {
      if (goal.goalMetric == "BooksRead" && goal.progress == goal.target) {
        if (getYearFromDateString(goal.endDate) == currYear) yearCount++;
        if (getMonthFromDateString(goal.endDate) == currMonth) monthCount++;
      }
    }

    return [yearCount, monthCount];
  }

  Widget _readingStats() {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_sharp, color: colorGreen, size: 24),
              addHorizontalSpace(8),
              Text(
                "Reading Stats",
                style: textTheme.titleMedium?.copyWith(
                  color: colorGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
          addVerticalSpace(16),
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _statCard("Books Finished\n(This Year)", booksReadYearCount.toString()),
                _statCard("Books Finished\n(This Month)", booksReadMonthCount.toString()),
                _statCard("Goals Completed\n(This Year)", goalsCompletedYearCount.toString()),
                _statCard("Goals Completed\n(This Month)", goalsCompletedMonthCount.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 182,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorGreyLight,
        border: Border.all(width: 1.5, color: colorGreen),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(8),
          Text(
            value,
            style: textTheme.titleMedium!.copyWith(color: colorGreenDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
