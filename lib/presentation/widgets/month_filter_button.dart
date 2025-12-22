// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

class MonthFilterButton extends StatelessWidget {
  final bool isAllTime;
  final DateTime? selectedMonth;
  final VoidCallback onTap;
  final bool isYearFilter;

  const MonthFilterButton({
    super.key,
    required this.isAllTime,
    this.selectedMonth,
    required this.onTap,
    this.isYearFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryIndigo, AppColors.accentPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryIndigo.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isAllTime
                      ? Icons.all_inclusive
                      : isYearFilter
                      ? Icons.calendar_today_outlined
                      : Icons.calendar_month,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  isAllTime
                      ? 'All Time'
                      : isYearFilter
                      ? DateFormat('yyyy').format(selectedMonth!)
                      : DateFormat('MMMM yyyy').format(selectedMonth!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}
