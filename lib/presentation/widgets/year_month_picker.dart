import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

class YearMonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const YearMonthPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<YearMonthPicker> createState() => _YearMonthPickerState();
}

class _YearMonthPickerState extends State<YearMonthPicker> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final years = List.generate(
      now.year - 2020 + 1,
      (index) => 2020 + index,
    ).reversed.toList();

    return Column(
      children: [
        // Year selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSlate700.withOpacity(0.5)
                : AppColors.borderSlate.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: _selectedYear,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.darkSlate700 : AppColors.surfaceWhite,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            items: years.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedYear = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        // Month grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final isSelected = month == _selectedMonth && _selectedYear == widget.initialDate.year;
              final isFuture = _selectedYear > now.year ||
                             (_selectedYear == now.year && month > now.month);

              return InkWell(
                onTap: isFuture
                    ? null
                    : () {
                        widget.onDateSelected(DateTime(_selectedYear, month));
                      },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.lightIndigo : AppColors.primaryIndigo)
                        : (isDark
                            ? AppColors.darkSlate700.withOpacity(0.3)
                            : AppColors.borderSlate.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.lightIndigo : AppColors.primaryIndigo)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('MMM').format(DateTime(2024, month)),
                      style: TextStyle(
                        color: isFuture
                            ? (isDark ? AppColors.darkTextTertiary : AppColors.textSecondary.withOpacity(0.5))
                            : isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
