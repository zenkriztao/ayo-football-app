import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';

/// AYO-style Filter Chip Widget
class AyoFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const AyoFilterChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.cardBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AYO-style Filter Row Widget
class AyoFilterRow extends StatelessWidget {
  final List<AyoFilterItem> filters;
  final int selectedIndex;
  final ValueChanged<int>? onFilterChanged;
  final bool showFilterButton;
  final VoidCallback? onFilterButtonTap;

  const AyoFilterRow({
    super.key,
    required this.filters,
    this.selectedIndex = 0,
    this.onFilterChanged,
    this.showFilterButton = false,
    this.onFilterButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showFilterButton) ...[
            _buildFilterButton(),
            const SizedBox(width: 8),
          ],
          ...filters.asMap().entries.map((entry) {
            final index = entry.key;
            final filter = entry.value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AyoFilterChip(
                label: filter.label,
                icon: filter.icon,
                isSelected: index == selectedIndex,
                onTap: () => onFilterChanged?.call(index),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: onFilterButtonTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Icon(
          Icons.tune,
          size: 20,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class AyoFilterItem {
  final String label;
  final IconData? icon;
  final String? value;

  const AyoFilterItem({
    required this.label,
    this.icon,
    this.value,
  });
}
