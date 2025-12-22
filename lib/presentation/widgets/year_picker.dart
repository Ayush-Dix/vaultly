// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class YearPicker extends StatefulWidget {
  final int initialYear;
  final Function(int) onYearSelected;

  const YearPicker({
    super.key,
    required this.initialYear,
    required this.onYearSelected,
  });

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final years = List.generate(
      now.year - 2020 + 1,
      (index) => 2020 + index,
    ).reversed.toList();

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final isSelected = year == _selectedYear;
        final isFuture = year > now.year;

        return InkWell(
          onTap: isFuture
              ? null
              : () {
                  widget.onYearSelected(year);
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.lightIndigo : AppColors.primaryIndigo)
                  : (isDark
                        ? AppColors.darkSlate700.withOpacity(0.3)
                        : AppColors.borderSlate.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppColors.lightIndigo : AppColors.primaryIndigo)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                year.toString(),
                style: TextStyle(
                  color: isFuture
                      ? (isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textSecondary.withOpacity(0.5))
                      : isSelected
                      ? Colors.white
                      : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
