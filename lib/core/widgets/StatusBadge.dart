import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';

/// AYO-style Status Badge Widget
class StatusBadge extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final Color? backgroundColor;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.isCompleted = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? _getBackgroundColor();
    final txtColor = textColor ?? _getTextColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: txtColor,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isCompleted) return AppTheme.successColor;
    return AppTheme.warningColor;
  }

  Color _getTextColor() {
    if (isCompleted) return AppTheme.successColor;
    return AppTheme.warningColor;
  }
}
