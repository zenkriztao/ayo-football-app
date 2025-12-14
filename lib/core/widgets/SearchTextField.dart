import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';

/// AYO-style Search TextField Widget
class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showLocationButton;
  final VoidCallback? onLocationTap;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.showLocationButton = false,
    this.onLocationTap,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppTheme.textTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          widget.onClear?.call();
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ),
        if (widget.showLocationButton) ...[
          const SizedBox(width: 12),
          _buildLocationButton(),
        ],
      ],
    );
  }

  Widget _buildLocationButton() {
    return GestureDetector(
      onTap: widget.onLocationTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppTheme.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Around me',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
