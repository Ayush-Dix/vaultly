import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SpendingLimitCard extends StatelessWidget {
  final double monthlyExpenses;
  final double monthlyLimit;

  const SpendingLimitCard({
    super.key,
    required this.monthlyExpenses,
    required this.monthlyLimit,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (monthlyExpenses / monthlyLimit) * 100;
    final remaining = monthlyLimit - monthlyExpenses;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Spending Limit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${monthlyLimit.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: isDark
                  ? AppColors.darkSlate700
                  : AppColors.borderSlate,
              color: percentage >= 100
                  ? (isDark ? AppColors.darkRose : AppColors.expenseRed)
                  : percentage >= 80
                  ? (isDark ? AppColors.darkAmber : AppColors.warningAmber)
                  : (isDark ? AppColors.darkEmerald : AppColors.incomeGreen),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              remaining >= 0
                  ? 'Remaining: ₹${remaining.toStringAsFixed(0)} (${(100 - percentage).toStringAsFixed(0)}%)'
                  : 'Exceeded by: ₹${(-remaining).toStringAsFixed(0)}',
              style: TextStyle(
                color: remaining >= 0
                    ? (isDark ? AppColors.darkEmerald : AppColors.incomeGreen)
                    : (isDark ? AppColors.darkRose : AppColors.expenseRed),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
