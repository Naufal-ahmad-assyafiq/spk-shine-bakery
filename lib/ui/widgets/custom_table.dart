import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final List<double>? columnWidths;

  const CustomTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.columnWidths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lightBrown, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder.symmetric(
            inside: const BorderSide(color: Color(0xFFEFEBE9), width: 1.0),
          ),
          columnWidths: columnWidths != null
              ? Map.fromIterables(
                  List.generate(columnWidths!.length, (index) => index),
                  columnWidths!.map((w) => FixedColumnWidth(w)),
                )
              : null,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: lightBrown,
              ),
              children: headers.map((header) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text(
                    header,
                    style: const TextStyle(
                      color: brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
            // Data Rows
            ...rows.map((row) {
              return TableRow(
                children: row.map((cell) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Center(child: cell),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
