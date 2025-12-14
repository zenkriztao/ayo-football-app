import 'package:flutter/material.dart';

/// Widget Card for displaying detailed information
/// Applying Single Responsibility Principle
class InfoCard extends StatelessWidget {
  final List<InfoRow> rows;

  const InfoCard({
    super.key,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: rows.map((row) => _buildInfoRow(row)).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoRow(InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: row.labelWidth,
            child: Text(
              row.label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model for information row
class InfoRow {
  final String label;
  final String value;
  final double labelWidth;

  const InfoRow({
    required this.label,
    required this.value,
    this.labelWidth = 100,
  });
}
