import 'dart:collection';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineGraph extends StatefulWidget {
  final Child selectedChild;
  const LineGraph({super.key, required this.selectedChild});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  late double baselineX;
  late double baselineY;
  late Map<int, int> completedList = HashMap();
  late Child selectedChild;

  final visibleWindowSize = 4;
  final numXLabels = 12;

  @override
  void initState() {
    super.initState();
    baselineX = (DateTime.now().month - 4).clamp(0, 12 - visibleWindowSize).toDouble();
    baselineY = 0.0;
    selectedChild = widget.selectedChild;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);

    if (selectedChild != appState.children[appState.selectedChildID]) {
      selectedChild = appState.children[appState.selectedChildID];
      completedList.clear();
    }
  
    // Return loading screen if bookshelves are yet to be initialized.
    if (selectedChild.bookshelves.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Once bookshelves are initialized, retrieve the completion dates.
    if (completedList.isEmpty) {
      _getCompletionDates(selectedChild);
    }

    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_graph_rounded, color: colorGreen, size: 24),
                  addHorizontalSpace(8),
                  Text(
                    "Reading Activity",
                    style: textTheme.titleMedium!.copyWith(
                      color: colorGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              addVerticalSpace(8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _yAxisLabel(),
                    addHorizontalSpace(8),
                    Expanded(
                      child: _Chart(
                        baselineX: baselineX,
                        baselineY: baselineY,
                        onPan: _handlePan,
                        booksRead: completedList,
                        visibleWindowSize: visibleWindowSize,
                        numXLabels: numXLabels
                      ),
                    ),
                  ],
                ),
              ),
              _xAxisLabel()
            ],
          ),
        ),
      ),
    );
  }

  // Sets the offset of the graph scroll.
  void _handlePan(double dx) {
    setState(() {
      baselineX = (baselineX - dx * 0.04).clamp(0.0, (numXLabels - visibleWindowSize).toDouble());
    });
  }

  // Parses the completion data to obtain a count of book completions per month.
  void _getCompletionDates(Child selectedChild) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final bookshelves = selectedChild.bookshelves;

    if (bookshelves.isEmpty) return;

    final index = bookshelves.indexWhere((b) => b.type == BookshelfType.completed);
    Bookshelf completedShelf = await appState.getChildBookshelf(appState.selectedChildID, index);
    completedList.clear();
    if (completedShelf.completedDates != null) {
      setState(() {
        for (Completion data in completedShelf.completedDates!) {
          final date = data.completedDate;
          int dateDay = getMonthFromDateString(date);
          completedList[dateDay] = (completedList[dateDay] ?? 0) + 1;
        }
      });
    }
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;
  final void Function(double delta) onPan;
  final Map<int, int> booksRead;
  final int visibleWindowSize;
  final int numXLabels;

  const _Chart({
    required this.baselineX,
    required this.baselineY,
    required this.onPan,
    required this.booksRead,
    required this.visibleWindowSize,
    required this.numXLabels
  });

  @override
  Widget build(BuildContext context) {
    final minX = baselineX;
    final maxX = (baselineX + visibleWindowSize).clamp(0.0, numXLabels.toDouble() - 1);

    final List<FlSpot> allSpots = [];
    int monthIndex = DateTime.now().month;
    for (int month = 0; month < monthIndex; month++) {
      allSpots.add(FlSpot(month.toDouble(), booksRead[month+1] == null ? 0 : booksRead[month+1]!.toDouble()));
    }

    final visibleSpots =
        allSpots.where((s) => s.x > minX && s.x <= maxX).toList();

    double chartRange = maxX - minX;
    double endOfX = baselineX + chartRange;

    List<FlSpot> points = [
      _getInterpolatedSpot(baselineX, booksRead, numXLabels), 
      ...visibleSpots, 
      if (endOfX < booksRead.length - 1) _getInterpolatedSpot(endOfX, booksRead, numXLabels)
    ];

    double maxY = allSpots.isNotEmpty
      ? allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
      : 0;

    double padding = maxY * 0.1;

    if (padding == 0) {
      padding = 1;
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) => onPan(details.delta.dx),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points,
              color: colorGreen.withAlpha(baselineX <= DateTime.now().month - 1 ? 255 : 0),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: colorGreen.withAlpha(75),
              ),
            ),
          ],
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: (maxY + padding).ceil().toDouble(),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) => _gridLine(),
            getDrawingVerticalLine: (_) => _gridLine(),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: _verticalLabels,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: _horizontalLabels,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: colorGreyDark),
              bottom: BorderSide(color: colorGreyDark),
            ),
          ),
        ),
        duration: Duration.zero,
      ),
    );
  }
}

// Labels for the y-axis (num books read).
Widget _yAxisLabel() {
  return RotatedBox(
    quarterTurns: 3,
    child: Text(
      'Books Read',
      style: TextStyle(
        color: colorGrey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Labels for the x-asis (months).
Widget _xAxisLabel() {
  return Text(
    'Months',
    style: TextStyle(
      color: colorGrey,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _horizontalLabels(double value, TitleMeta meta) {
  const monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  return Text(
    monthLabels[value.toInt()],
    style: const TextStyle(color: colorGrey, fontSize: 12),
  );
}

Widget _verticalLabels(double value, TitleMeta meta) {
  return Text(
    meta.formattedValue,
    style: const TextStyle(color: colorGrey, fontSize: 12),
  );
}

FlLine _gridLine() {
  return FlLine(
    color: colorGrey.withAlpha(75),
    strokeWidth: 1,
    dashArray: [4, 4],
  );
}

// Retrieves the first and last cut-off points of the graph.
FlSpot _getInterpolatedSpot(double x, Map<int, int> data, int numXLabels) {
  int low = x.floor();
  int high = x.ceil();

  // Clamp to valid range.
  if (high >= numXLabels) high = numXLabels - 1;
  if (low < 0) low = 0;

  // +1 since the data starts with Jan (1).
  double yLow = data[low + 1]?.toDouble() ?? 0.0;
  double yHigh = data[high + 1]?.toDouble() ?? 0.0;

  if (low == high) {
    return FlSpot(x, yLow);
  }

  double weight = (x - low) / (high - low);
  double y = yLow + weight * (yHigh - yLow);

  return FlSpot(x, y);
}
