import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';

class ReadingLevelInfoWidget extends StatelessWidget {
  const ReadingLevelInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom("Reading Level Info"),
      body: Column(
        children: [
          addVerticalSpace(24),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: const Text(
              "Reading levels are a way to measure the difficulty of a book. The following table shows the different reading levels and their corresponding Lexile, Fountas & Pinnell (F&P), and Advantage-TASA Open Standard (ATOS) levels:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          ),
          addVerticalSpace(12.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(color: context.colors.onSurface),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow(['Level', 'Lexile', 'F&P', 'ATOS'], isHeader: true),
                _buildTableRow(['0-10', 'BR-100', 'A–C', '0.0–0.84']),
                _buildTableRow(['11-20', '101–200', 'D–F', '0.85–1.54']),
                _buildTableRow(['21-30', '201–300', 'G–I', '1.55–2.19']),
                _buildTableRow(['31-40', '301–400', 'J–K', '2.2–2.79']),
                _buildTableRow(['41-50', '401–500', 'L–M', '2.8–3.59']),
                _buildTableRow(['51-60', '501–600', 'N–O', '3.6–3.84']),
                _buildTableRow(['61-70', '601–700', 'O–P', '3.85–4.29']),
                _buildTableRow(['71-80', '701–800', 'Q–S', '4.3–4.84']),
                _buildTableRow(['81-90', '801–900', 'S–U', '4.85–5.44']),
                _buildTableRow(['91-100', '901–1000', 'V–W', '5.45–5.89']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}