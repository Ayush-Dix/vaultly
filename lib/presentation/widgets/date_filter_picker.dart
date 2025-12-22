// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../screens/transactions_screen.dart';
import 'year_month_picker.dart';
import 'year_picker.dart' as custom;
import 'package:intl/intl.dart';

class DateFilterPicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime?) onDateSelected;
  final Function(DateTime?) onMonthSelected;
  final Function(DateTime?) onYearSelected;
  final VoidCallback onClearFilter;
  final FilterMode filterMode;

  const DateFilterPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthSelected,
    required this.onYearSelected,
    required this.onClearFilter,
    required this.filterMode,
  });

  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.lightIndigo,
                    onPrimary: Colors.white,
                    surface: AppColors.darkSlate800,
                    onSurface: AppColors.darkTextPrimary,
                  )
                : ColorScheme.light(
                    primary: AppColors.primaryIndigo,
                    onPrimary: Colors.white,
                    surface: AppColors.surfaceWhite,
                    onSurface: AppColors.textPrimary,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _showFilterOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSlate800 : AppColors.surfaceWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkTextTertiary.withOpacity(0.5)
                    : AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Filter Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: isDark ? AppColors.lightIndigo : AppColors.primaryIndigo,
              ),
              title: Text(
                'Filter by Specific Date',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _selectDate(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: isDark ? AppColors.lightPurple : AppColors.accentPurple,
              ),
              title: Text(
                'Filter by Month',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _selectMonth(context);
                if (picked != null) {
                  onMonthSelected(picked);
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today_outlined,
                color: isDark ? AppColors.lightCyan : AppColors.accentCyan,
              ),
              title: Text(
                'Filter by Year',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _selectYear(context);
                if (picked != null) {
                  onYearSelected(picked);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectMonth(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime? pickedMonth;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSlate800
            : AppColors.surfaceWhite,
        title: Text(
          'Select Month',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearMonthPicker(
            initialDate: selectedDate,
            onDateSelected: (date) {
              pickedMonth = date;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );

    return pickedMonth;
  }

  Future<DateTime?> _selectYear(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime? pickedYear;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSlate800
            : AppColors.surfaceWhite,
        title: Text(
          'Select Year',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: custom.YearPicker(
            initialYear: selectedDate.year,
            onYearSelected: (year) {
              pickedYear = DateTime(year);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );

    return pickedYear;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFiltered = filterMode != FilterMode.none;

    String filterText;
    String filterLabel;

    if (filterMode == FilterMode.date) {
      filterLabel = 'Filtered by date';
      filterText = DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate);
    } else if (filterMode == FilterMode.month) {
      filterLabel = 'Filtered by month';
      filterText = DateFormat('MMMM yyyy').format(selectedDate);
    } else if (filterMode == FilterMode.year) {
      filterLabel = 'Filtered by year';
      filterText = DateFormat('yyyy').format(selectedDate);
    } else {
      filterLabel = 'All Transactions';
      filterText = 'Tap to filter';
    }

    return InkWell(
      onTap: () => !isFiltered ? _showFilterOptions(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.lightIndigo.withOpacity(0.15),
                    AppColors.lightPurple.withOpacity(0.15),
                  ]
                : [
                    AppColors.primaryIndigo.withOpacity(0.1),
                    AppColors.accentPurple.withOpacity(0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkSlate700 : AppColors.borderSlate,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              filterMode == FilterMode.month
                  ? Icons.calendar_month
                  : Icons.calendar_today,
              color: isDark ? AppColors.lightIndigo : AppColors.primaryIndigo,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filterLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    filterText,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (isFiltered)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: isDark ? AppColors.darkRose : AppColors.expenseRed,
                ),
                onPressed: onClearFilter,
                tooltip: 'Clear filter',
              )
            else
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: isDark
                      ? AppColors.lightIndigo
                      : AppColors.primaryIndigo,
                ),
                onPressed: () => _showFilterOptions(context),
              ),
          ],
        ),
      ),
    );
  }
}
