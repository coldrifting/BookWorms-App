import 'dart:math';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({super.key});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  double baselineX = 0.0;
  double baselineY = 0.0;

  final List<int> booksRead = List.generate(30, (_) => Random().nextInt(11));
  final List<String> graphSwitch = ["By Day", "By Month"];
  int graphIndex = 0;

  void _handlePan(double dx) {
    setState(() {
      baselineX = (baselineX - dx * 0.04).clamp(0.0, 20.0);
    });
  }

  Widget _yAxisLabel() {
  return RotatedBox(
    quarterTurns: 3,
    child: Text(
      'Books Read',
      style: TextStyle(
        color: context.colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

  Widget _xAxisLabel() {
    return Text(
      graphIndex == 0 ? 'Days' : 'Months',
      style: TextStyle(
        color: context.colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.surfaceBorder,
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
                  Icon(Icons.auto_graph_rounded, color: context.colors.primary, size: 24),
                  addHorizontalSpace(8),
                  Text(
                    "Reading Activity",
                    style: textTheme.titleMedium!.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 24,
                    width: 76,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          graphIndex = graphIndex == 0 ? 1 : 0;
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.onSurfaceDim,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(graphSwitch[graphIndex], style: textTheme.labelSmall!.copyWith(color: context.colors.greyDark))
                    ),
                  ),
                  addHorizontalSpace(8)
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
                        booksRead: booksRead,
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
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;
  final void Function(double delta) onPan;
  final List<int> booksRead;

  const _Chart({
    required this.baselineX,
    required this.baselineY,
    required this.onPan,
    required this.booksRead,
  });

  Widget _horizontalLabels(BuildContext context, double value, TitleMeta meta) {
    final minX = baselineX;
    final maxX = baselineX + 10;
    double endOfX = baselineX + maxX - minX;

    if ((value - baselineX).abs() == 0 || (value - endOfX).abs() == 0) {
      return SizedBox.shrink();
    }

    return Text(
      value.toStringAsFixed(0),
      style: TextStyle(color: context.colors.grey, fontSize: 12),
    );
  }

  Widget _verticalLabels(BuildContext context, double value, TitleMeta meta) {
    return Text(
      meta.formattedValue,
      style: TextStyle(color: context.colors.grey, fontSize: 12),
    );
  }

  FlLine _gridLine(BuildContext context) {
    return FlLine(
      color: context.colors.grey.withAlpha(75),
      strokeWidth: 1,
      dashArray: [4, 4],
    );
  }

  @override
  Widget build(BuildContext context) {
    final minX = baselineX;
    final maxX = baselineX + 10;

    final List<FlSpot> allSpots = List.generate(
      booksRead.length,
      (i) => FlSpot(i.toDouble(), booksRead[i].toDouble()),
    );

    final visibleSpots =
        allSpots.where((s) => s.x >= minX && s.x <= maxX).toList();

    double chartRange = maxX - minX;
    double endOfX = baselineX + chartRange;

    List<FlSpot> points = [
      _getInterpolatedSpot(baselineX, booksRead), 
      ...visibleSpots, 
      if (endOfX < booksRead.length - 1) ...[_getInterpolatedSpot(endOfX, booksRead)]
    ];

    return GestureDetector(
      onHorizontalDragUpdate: (details) => onPan(details.delta.dx),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points,
              color: context.colors.primary,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: context.colors.primary.withAlpha(75),
              ),
            ),
          ],
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: 10,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) => _gridLine(context),
            getDrawingVerticalLine: (_) => _gridLine(context),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) => _verticalLabels(context, value, meta)
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) => _horizontalLabels(context, value, meta)
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: context.colors.greyDark),
              bottom: BorderSide(color: context.colors.greyDark),
            ),
          ),
        ),
        duration: Duration.zero,
      ),
    );
  }
}


// Retrieves the first and last cut-off points of the graph.
FlSpot _getInterpolatedSpot(double x, List<int> data) {
  int low = x.floor();
  int high = x.ceil();
  if (high >= data.length) high = data.length - 1;

  double y = data[low] + (x - low) * (data[high] - data[low]);
  return FlSpot(x, y);
}
